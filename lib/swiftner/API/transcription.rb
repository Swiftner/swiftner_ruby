# frozen_string_literal: true

module Swiftner
  module API
    # Represents a Transcription service responsible for finding, creating, and deleting transcriptions.
    # Inherits from the Service class.
    # Provides methods for interacting with transcriptions.
    class Transcription < Service
      def self.find(transcription_id)
        response = Base.client.get("/transcription/get/#{transcription_id}")
        build(response.parsed_response)
      end

      def self.create(attributes)
        response = Base.client.post(
          "/transcription/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      def delete
        client.delete("/transcription/delete/#{id}")
      end
    end
  end
end
