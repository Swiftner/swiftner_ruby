# frozen_string_literal: true

module Swiftner
  module API
    # Represents a Space service responsible for finding, creating, and deleting spaces.
    # Inherits from the Service class.
    # Provides methods for interacting with spaces.
    class Space < Service
      def self.find_spaces
        response = client.get("/space/get-spaces")
        map_collection(response)
      end

      def self.find(space_id)
        response = client.get("/space/get/#{space_id}")
        build(response.parsed_response)
      end

      def self.create(attributes)
        validate_required(attributes, :name, :description)

        response = client.post(
          "/space/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

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

      def delete
        client.delete("/space/delete/#{id}")
      end
    end
  end
end
