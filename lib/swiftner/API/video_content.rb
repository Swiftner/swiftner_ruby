# frozen_string_literal: true

module Swiftner
  module API
    # VideoContent class represents video content in the Swiftner API.
    # It allows you to find and update video content.
    class VideoContent < Service
      # Finds all video contents
      # @return [Array<Swiftner::API::VideoContent>]
      def self.find_video_contents
        response = client.get("/video-content/get-all/")
        map_collection(response)
      end

      # Finds video content by id
      # @param [Integer] id
      # @return [Swiftner::API::VideoContent]
      def self.find(id)
        response = client.get("/video-content/get/#{id}")
        build(response.parsed_response)
      end

      # Updates video content
      # @param [Hash] attributes
      # @option attributes [String] :title (optional)
      # @option attributes [String] :description (optional)
      # @option attributes [String] :start (optional)
      # @option attributes [Integer] :duration (optional)
      # @option attributes [String] :path (optional)
      # @option attributes [String] :thumbnail_url (optional)
      # @option attributes [String] :audio_url (optional)
      # @option attributes [String] :language (optional)
      # @option attributes [Integer] :prompt_id (optional)
      # @return [Swiftner::API::VideoContent]
      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)
        self.class.validate_language(@details)

        client.put(
          "/video-content/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end

      # Created a url to the embedded editor
      # @return [String] url to editor
      def create_editor_link
        result = client.post(
          "/video-content/create_editor_link/#{id}",
          body: {}.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        result["url"]
      end
    end
  end
end
