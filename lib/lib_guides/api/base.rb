module LibGuides
  module API
    class Base
      attr_reader :current_token, :token_expires_at

      def execute(verb, path, params={})
        response = connection.public_send(verb) do |req|
          req.url "/#{API_VERSION}#{path}"
          req.headers["Authorization"] = "Bearer #{token}"
          req.body = params
        end
        parse_response(response)
      end

      def token
        return current_token unless token_expired?
        @current_token = get_token
      end

      def token_expired?
        !current_token || token_expires_at <= Time.now
      end

      def get_token
        response = connection.post('/1.2/oauth/token', {
          client_id: ENV['LIB_GUIDES_CLIENT_ID'],
          client_secret: ENV['LIB_GUIDES_CLIENT_SECRET'],
          grant_type: 'client_credentials'
        })
        json = JSON.parse(response.body)
        @token_expires_at = Time.now + json["expires_in"].to_i
        json["access_token"]
      end

      def connection
        @conn ||= Faraday.new(url: 'http://lgapi-us.libapps.com')
      end

      private

      def parse_response(response)
        if response.success?
          json = JSON.parse(response.body)
          if json.is_a?(Hash) && json["error"]
            raise ::LibGuides::API::Error.new(response)
          else
            return JSON.parse(response.body)
          end
        else
          raise ::LibGuides::API::Error.new(response)
        end
      end
    end
  end
end
