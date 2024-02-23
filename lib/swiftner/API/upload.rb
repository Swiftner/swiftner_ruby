# frozen_string_literal: true

module Swiftner
  module API
    # The `Upload` class is responsible for managing uploads in the Swiftner API.
    # It provides methods for finding uploads, creating uploads, deleting uploads, and retrieving transcriptions related
    # to an upload.
    class Upload < Service
      def self.find_uploads
        response = client.get("/upload/get-uploads/")
        map_collection(response)
      end

      def self.find(upload_id)
        response = client.get("/upload/get/#{upload_id}")
        build(response.parsed_response)
      end

      def self.create(attributes)
        response = client.post(
          "/upload/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        build(response.parsed_response) if response.success?
      end

      def delete
        client.delete("/upload/delete/#{id}")
      end

      def transcriptions
        response = client.get("/upload/get/#{id}/transcriptions")
        response.map { |transcription| API::Transcription.build(transcription) }
      end

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
