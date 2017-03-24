module LibGuides
  module API
    module V1_2
      class Error < StandardError
        attr_reader :faraday_response, :json_response

        def initialize(faraday_response)
          @faraday_response = faraday_response
          @json_response = JSON.parse(@faraday_response.body)
          super(message)
        end

        def message
          "#{json_response["error"]}: #{json_response["error_description"]}"
        end
      end
    end
  end
end
