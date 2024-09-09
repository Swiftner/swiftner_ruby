# frozen_string_literal: true

module Swiftner
  module API
    # Represents a Meeting service responsible for finding, creating, and deleting spaces.
    # Inherits from the Service class.
    # Provides methods for interacting with recording.
    class Recording < Service
      REQUIRED_ATTRIBUTES = %i[start path channel_id meeting_id].freeze
      # Finds all recordings
      # @return [Array<Swiftner::API::Recording>]
      def self.find_recordings
        response = client.get("/recording/get_recordings")
        map_collection(response)
      end

      # Finds recording by id
      # @param [Integer] recording_id
      # @return [Swiftner::API::Recording]
      def self.find(recording_id)
        response = client.get("/recording/get/#{recording_id}")
        build(response.parsed_response)
      end

      # Creates a Recording.
      # @param [Hash] attributes
      # @option attributes [String] :start (required)
      # @option attributes [String] :path (required)
      # @option attributes [Integer] :channel_id (required)
      # @option attributes [Integer] :meeting_id (required)
      # @option attributes [String] :title (optional)
      # @option attributes [String] :description (optional)
      # @option attributes [Integer] :duration (optional)
      # @option attributes [String] :thumbnail_url (optional)
      # @option attributes [Boolean] :import_video_content_id (optional)
      # @option attributes [Boolean] :transfer_data (optional)
      # @return [Swiftner::API::Recording]
      def self.create(attributes)
        validate_required(attributes, *REQUIRED_ATTRIBUTES)

        response = client.post(
          "/recording/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      # Creates a Recording.
      # @param [Hash] attributes
      # @option attributes [String] :start (optional)
      # @option attributes [String] :path (optional)
      # @option attributes [Integer] :channel_id (optional)
      # @option attributes [Integer] :meeting_id (optional)
      # @option attributes [String] :title (optional)
      # @option attributes [String] :description (optional)
      # @option attributes [Integer] :duration (optional)
      # @option attributes [String] :thumbnail_url (optional)
      # @option attributes [Boolean] :import_video_content_id (optional)
      # @option attributes [Boolean] :transfer_data (optional)
      # @return [Swiftner::API::Recording]
      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)

        self.class.validate_required(@details, :id, :channel_id)

        client.put(
          "/recording/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end

      # Deletes a recording.
      # @return [Hash]
      def delete
        client.delete("/recording/delete/#{id}")
      end
    end
  end
end
