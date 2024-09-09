# frozen_string_literal: true

module Swiftner
  module API
    # Represents a Space service responsible for finding, creating, and deleting spaces.
    # Inherits from the Service class.
    # Provides methods for interacting with spaces.
    class Space < Service
      # Finds all spaces
      # @return [Array<Swiftner::API::Space>]
      def self.find_spaces
        response = client.get("/space/get-spaces")
        map_collection(response)
      end

      # Finds space by id
      # @param [Integer] space_id
      # @return [Swiftner::API::Space]
      def self.find(space_id)
        response = client.get("/space/get/#{space_id}")
        build(response.parsed_response)
      end

      # Creates a space.
      # @param [Hash] attributes
      # @option attributes [String] :name (required)
      # @option attributes [String] :description (required)
      # @option attributes [Integer] :prompt_id (optional)
      def self.create(attributes)
        validate_required(attributes, :name, :description)

        response = client.post(
          "/space/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      # Updates space
      # @param [Hash] attributes
      # @option attributes [String] :name (optional)
      # @option attributes [String] :description (optional)
      # @option attributes [Integer] :prompt_id (optional)
      # @return [Swiftner::API::Space]
      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)

        self.class.validate_required(@details, :name, :description)

        client.put(
          "/space/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end

      # Deletes space
      # @return [Hash]
      def delete
        client.delete("/space/delete/#{id}")
      end
    end
  end
end
