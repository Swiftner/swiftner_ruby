# frozen_string_literal: true

module Swiftner
  module API
    # Represents a Channel service responsible for finding, creating, updating and deleting channels.
    # Inherits from the Service class.
    # Provides methods for interacting with channel.
    class Channel < Service
      REQUIRED_ATTRIBUTES = %i[name type space_id].freeze

      # Finds all channels
      # @return [Array<Swiftner::API::Channel>]
      def self.find_channels
        response = client.get("/channel/get-channels")
        map_collection(response)
      end

      # Finds channel by its id
      # @param [Integer] channel_id
      # @return [Swiftner::API::Channel]
      def self.find(channel_id)
        response = client.get("/channel/get/#{channel_id}")
        build(response.parsed_response)
      end

      # @param [Hash] attributes
      # @option attributes [String] :name (required)
      # @option attributes [String] :type (required) - "audio", "video" or "dual"
      # @option attributes [Integer] :space_id (required)
      # @option attributes [String] :description (optional)
      # @option attributes [Integer] :order (optional)
      # @return [Swiftner::API::Channel]
      def self.create(attributes)
        validate_required(attributes, *REQUIRED_ATTRIBUTES)

        response = client.post(
          "/channel/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      # @return [Boolean]
      def live?
        client.get("/channel/is_channel_live?channel_id=#{id}")["status"] == "live"
      rescue Swiftner::NotFound
        # Why does api return 404 when channel is not live?
        false
      end

      # @param [Hash] attributes
      # @option attributes [String] :name (required)
      # @option attributes [String] :type (required) - "audio", "video" or "dual"
      # @option attributes [Integer] :space_id (required)
      # @option attributes [String] :description (optional)
      # @option attributes [Integer] :order (optional)
      # @return [Swiftner::API::Channel]
      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)

        self.class.validate_required(@details, *REQUIRED_ATTRIBUTES)

        client.put(
          "/channel/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end

      # Deletes channel by its id
      # @return [Hash] response
      def delete
        client.delete("/channel/delete/#{id}")
      end
    end
  end
end
