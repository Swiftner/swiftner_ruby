# frozen_string_literal: true

module Swiftner
  module API
    # Represents a chapter service responsible for finding, creating, and deleting chapters.
    # Inherits from the Service class.
    # Provides methods for interacting with chapters.
    class Chapter < Service
      REQUIRED_ATTRIBUTES = %i[title duration video_content_id start].freeze
      # Finds all chapters for a video content.
      # @param [Integer] video_content_id
      # @return [Array<Swiftner::API::Chapter>]
      def self.find_chapters(video_content_id)
        response = client.get("/video-content/get/#{video_content_id}/chapters")
        map_collection(response)
      end

      # Finds chapter by id.
      # @param [Integer] chapter_id
      # @return [Swiftner::API::Chapter]
      def self.find(chapter_id)
        response = client.get("/chapter/get/#{chapter_id}")
        build(response.parsed_response)
      end

      # Creates a chapter.
      # @param [Hash] attributes
      # @option attributes [String] :title (required)
      # @option attributes [String] :duration (required)
      # @option attributes [Integer] :video_content_id (required)
      # @option attributes [String] :start (required)
      # @option attributes [String] :start_seconds (optional)
      # @option attributes [String] :language (optional)
      # @return [Swiftner::API::Chapter]
      def self.create(attributes)
        validate_required(attributes, *REQUIRED_ATTRIBUTES)
        validate_language(attributes)

        response = client.post(
          "/chapter/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      # Creates a chapter.
      # @param [Hash] attributes
      # @option attributes [String] :title (optional)
      # @option attributes [String] :duration (optional)
      # @option attributes [Integer] :video_content_id (optional)
      # @option attributes [String] :start (optional)
      # @option attributes [String] :start_seconds (optional)
      # @option attributes [String] :language (optional)
      # @return [Swiftner::API::Chapter]
      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)

        self.class.validate_required(@details, *REQUIRED_ATTRIBUTES)
        self.class.validate_language(@details)

        client.put(
          "/chapter/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end

      # @return [Hash]
      def delete
        client.delete("/chapter/delete/#{id}")
      end
    end
  end
end
