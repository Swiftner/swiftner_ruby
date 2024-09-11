# frozen_string_literal: true

module Swiftner
  module API
    # Represents a Transcription service responsible for finding, creating, and deleting transcriptions.
    # Inherits from the Service class.
    # Provides methods for interacting with transcriptions.
    class Transcription < Service
      # Finds transcription by id
      # @return [Swiftner::API::Transcription]
      def self.find(transcription_id)
        response = client.get("/transcription/get/#{transcription_id}")
        build(response.parsed_response)
      end

      # Creates a transcription.
      # @param [Hash] attributes
      # @option attributes [String] :start (required)
      # @option attributes [Integer] :duration (required)
      # @option attributes [Boolean] :video_content_id (required)
      # @option attributes [String] :language (optional)
      # @option attributes [String] :state (optional)
      # @option attributes [String] :prompt_id (optional)
      # @option attributes [Boolean] :published (optional)
      def self.create(attributes)
        validate_required(attributes, :start, :duration, :video_content_id)
        validate_language(attributes)
        response = client.post(
          "/transcription/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      # Deletes transcription
      # @return [Hash]
      def delete
        client.delete("/transcription/delete/#{id}")
      end
    end
  end
end
