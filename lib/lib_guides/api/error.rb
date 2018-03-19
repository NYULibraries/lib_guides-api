module LibGuides
  module API
    class Error < StandardError
      attr_reader :faraday_response, :json_response

      def initialize(faraday_response)
        @faraday_response = faraday_response
        super(message)
      end

      def message
        @message ||= generate_message
      end

      def generate_message
        (parsed_message + "\n#{response_body}").strip
      end

      def parsed_message
        [
          json_message,
          ("(#{reason_phrase})" if reason_phrase),
        ].compact.join(" ")
      end

      def reason_phrase
        return unless faraday_response.reason_phrase
        return unless faraday_response.reason_phrase.strip.length > 0
        faraday_response.reason_phrase
      end

      def json_message
        return unless json_response
        "#{json_response["error"]}: #{json_response["error_description"]}"
      end

      def json_response
        return unless response_body
        @json_response ||= JSON.parse(response_body)
      rescue JSON::ParserError => e
        nil
      end

      private
      def response_body
        faraday_response.body
      end
    end
  end
end
