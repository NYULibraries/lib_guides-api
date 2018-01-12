module LibGuides
  module API
    class Error < StandardError
      attr_reader :faraday_response, :json_response

      def initialize(faraday_response)
        @faraday_response = faraday_response
        super(message)
      end

      def message
        @message ||= reason_phrase || generate_message
      end

      def reason_phrase
        return unless faraday_response.reason_phrase
        return unless faraday_response.reason_phrase.strip.length > 0
        faraday_response.reason_phrase
      end

      def generate_message
        @json_response = JSON.parse(@faraday_response.body)
        generate_message_from_json
      rescue JSON::ParserError => e
        @faraday_response.body
      end

      def generate_message_from_json
        "#{json_response["error"]}: #{json_response["error_description"]}"
      end
    end
  end
end
