# frozen_string_literal: true

module Swiftner
  module API
    # Represents a Organisation service responsible for finding, creating, and deleting organisations.
    # Inherits from the Service class.
    # Provides methods for interacting with spaces.
    class Organisation < Service
      REQUIRED_ATTRIBUTES = %i[name].freeze

      # Finds all organisations user is in
      # @return [Array<Swiftner::API::Organisation>]
      def self.find_organisations
        response = client.get("/organisation/get-current-user-orgs")
        map_collection(response)
      end

      # Finds organisation by id
      # @param [Integer] organisation_id
      # @return [Swiftner::API::Organisation]
      def self.find(organisation_id)
        response = client.get("/organisation/get/#{organisation_id}")
        build(response.parsed_response)
      end

      # Add org to token
      # @param [Integer] organisation_id
      # @return [Hash] {access_hash: String, refresh_token: String}
      def self.add_org_to_token(organisation_id)
        client.put("/organisation/add-org-to-token?organisation_id=#{organisation_id}")
      end

      # Creates a new organisation
      # @param [Hash] attributes
      # @option attributes [String] :name (required)
      # @option attributes [String] :description (optional)
      # @option attributes [Integer] :default_prompt_id (optional)
      # @option attributes [String] :language (optional)
      # @return [Swiftner::API::Organisation]
      def self.create(attributes)
        validate_required(attributes, *REQUIRED_ATTRIBUTES)
        response = client.post(
          "/organisation/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        build(response.parsed_response)
      end

      # Updates organisation
      # @param [Hash] attributes
      # @option attributes [String] :name (optional)
      # @option attributes [String] :description (optional)
      # @option attributes [Integer] :default_prompt_id (optional)
      # @option attributes [String] :language (optional)
      # @return [Swiftner::API::Organisation]
      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)

        self.class.validate_required(@details, *REQUIRED_ATTRIBUTES)

        client.put(
          "/organisation/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end

      # Deletes organisation
      def delete
        client.delete("/organisation/delete/#{id}")
      end
    end
  end
end
