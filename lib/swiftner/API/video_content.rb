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
      # @return [Swiftner::API::VideoContent]
      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)

        client.put(
          "/video-content/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end
    end
  end
end
