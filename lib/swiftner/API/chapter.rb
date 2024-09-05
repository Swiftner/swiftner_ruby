# frozen_string_literal: true

module Swiftner
  module API
    # Represents a chapter service responsible for finding, creating, and deleting chapters.
    # Inherits from the Service class.
    # Provides methods for interacting with chapters.
    class Chapter < Service
      def self.find_chapters(video_content_id)
        response = client.get("/video-content/get/#{video_content_id}/chapters")
        map_collection(response)
      end

      def self.find(chapter_id)
        response = client.get("/chapter/get/#{chapter_id}")
        build(response.parsed_response)
      end

      def self.create(attributes)
        validate_required(attributes, :title, :start, :duration, :video_content_id)

        response = client.post(
          "/chapter/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)

        self.class.validate_required(@details, :title, :start, :duration)

        client.put(
          "/chapter/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end

      def delete
        client.delete("/chapter/delete/#{id}")
      end
    end
  end
end
