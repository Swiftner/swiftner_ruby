# frozen_string_literal: true

module Swiftner
  module API
    # Represents a Prompt service responsible for finding, creating, and deleting prompts.
    # Inherits from the Service class.
    # Provides methods for interacting with prompts.
    class Prompt < Service
      REQUIRED_ATTRIBUTES = %i[text].freeze
      # Finds all prompts
      # @return [Array<Swiftner::API::Prompt>]
      def self.find_prompts
        response = client.get("/prompt/get-prompts")
        map_collection(response)
      end

      # Finds prompt by id
      # @param [Integer] prompt_id
      # @return [Swiftner::API::Prompt]
      def self.find(prompt_id)
        response = client.get("/prompt/get/#{prompt_id}")
        build(response.parsed_response)
      end

      # Creates a prompt.
      # @param [Hash] attributes
      # @option attributes [String] :text (required)
      # @option attributes [String] :description (optional)
      def self.create(attributes)
        validate_required(attributes, *REQUIRED_ATTRIBUTES)
        validate_language(attributes)

        response = client.post(
          "/prompt/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      # Updates prompt
      # @param [Hash] attributes
      # @option attributes [String] :text (optional)
      # @option attributes [String] :description (optional)
      # @return [Swiftner::API::Prompt]
      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)

        self.class.validate_required(@details, *REQUIRED_ATTRIBUTES)
        self.class.validate_language(@details)

        client.put(
          "/prompt/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end

      # Deletes prompt
      # @return [Hash]
      def delete
        client.delete("/prompt/delete/#{id}")
      end
    end
  end
end
