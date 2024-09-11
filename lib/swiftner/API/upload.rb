# frozen_string_literal: true

module Swiftner
  module API
    # The `Upload` class is responsible for managing uploads in the Swiftner API.
    # It provides methods for finding uploads, creating uploads, deleting uploads, and retrieving transcriptions related
    # to an upload.
    class Upload < Service
      # Finds all uploads
      # @return [Array<Swiftner::API::Upload>]
      def self.find_uploads
        response = client.get("/upload/get-uploads")
        map_collection(response)
      end

      # Finds upload by id
      # @param [Integer] upload_id
      # @return [Swiftner::API::Upload]
      def self.find(upload_id)
        response = client.get("/upload/get/#{upload_id}")
        build(response.parsed_response)
      end

      # Creates an upload.
      # @param [Hash] attributes
      # @option attributes [String] :title (optional)
      # @option attributes [String] :description (optional)
      # @option attributes [String] :start (optional)
      # @option attributes [String] :language (optional)
      # @option attributes [String] :path (optional)
      # @option attributes [String] :thumbnail_url (optional)
      # @option attributes [String] :audio_url (optional)
      # @option attributes [Integer] :prompt_id (optional)
      def self.create(attributes)
        validate_language(attributes)
        response = client.post(
          "/upload/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        build(response.parsed_response) if response.success?
      end

      # Deletes upload
      # @return [Hash]
      def delete
        client.delete("/upload/delete/#{id}")
      end

      # Retrieves transcriptions related to an upload
      # @return [Array<Swiftner::API::Transcription>]
      def transcriptions
        response = client.get("/upload/get/#{id}/transcriptions")
        response.map { |transcription| API::Transcription.build(transcription) }
      end

      # Transcribes an upload
      # @param [String] language
      # @return [Swiftner::API::Transcription]
      def transcribe(language)
        transcription = {
          video_content_id: id,
          language: language,
          start: 0.0,
          end: details["duration"],
          duration: details["duration"]
        }
        API::Transcription.create(transcription)
      end
    end
  end
end
