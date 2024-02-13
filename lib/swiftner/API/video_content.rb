# frozen_string_literal: true

module Swiftner
  module API
    # VideoContent class represents video content in the Swiftner API.
    # It allows you to find and update video content.
    class VideoContent < Service
      def self.find_video_contents
        response = Base.client.get("/video-content/get-all/")
        response.map { |upload| build(upload) }
      end

      def self.find(id)
        response = Base.client.get("/video-content/get/#{id}")
        build(response.parsed_response)
      end

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
