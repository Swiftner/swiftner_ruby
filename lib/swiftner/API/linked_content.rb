# frozen_string_literal: true

module Swiftner
  module API
    # Represents a LinkedContent service responsible for finding, creating, and updating linked content.
    # Inherits from the Service class.
    # Provides methods for interacting with linked content.
    class LinkedContent < Service
      # Find all linked contents
      # @return [Array<Swiftner::API::LinkedContent>]
      def self.find_linked_contents
        response = client.get("/linked-content/get-all/")
        map_collection(response)
      end

      # Find linked content by id
      # @param [Integer] linked_content_id
      # @return [Swiftner::API::LinkedContent]
      def self.find(linked_content_id)
        response = client.get("/linked-content/get/#{linked_content_id}")
        build(response.parsed_response)
      end

      # Creates a linked content.
      # @param [Hash] attributes
      # @option attributes [String] :url (required)
      # @option attributes [String] :title (optional)
      # @option attributes [String] :description (optional)
      # @option attributes [String] :start (optional)
      # @option attributes [String] :language (optional)
      # @option attributes [String] :thumbnail_url (optional)
      # @option attributes [Integer] :duration (optional)
      # @option attributes [Object] :meta (optional)
      # @option attributes [Integer] :prompt_id (optional)
      # @return [Swiftner::API::LinkedContent]
      def self.create(attributes)
        validate_required(attributes, :url)

        response = client.post(
          "/linked-content/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      # Creates multiple linked contents.
      # @param [Array<Hash>] array_of_attributes
      # @return [Array<Swiftner::API::LinkedContent>]
      def self.batch_create(array_of_attributes)
        array_of_attributes.each { |attributes| validate_required(attributes, :url) }

        response = client.post(
          "/linked-content/batch-create",
          body: array_of_attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        map_collection(response)
      end

      # Updates a linked content.
      # @param [Hash] attributes
      # @option attributes [String] :url (optional)
      # @option attributes [String] :title (optional)
      # @option attributes [String] :description (optional)
      # @option attributes [String] :start (optional)
      # @option attributes [String] :language (optional)
      # @option attributes [String] :thumbnail_url (optional)
      # @option attributes [Integer] :duration (optional)
      # @option attributes [Object] :meta (optional)
      # @option attributes [Integer] :prompt_id (optional)
      # @return [Swiftner::API::LinkedContent]
      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)

        client.put(
          "/linked-content/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end

      # Gets all transcriptions for a linked content.
      # @return [Array<Swiftner::API::Transcription>]
      def transcriptions
        response = client.get("/linked-content/get/#{id}/transcriptions")
        response.map { |transcription| API::Transcription.build(transcription) }
      end

      # Deletes a linked content.
      # @return [Hash]
      def delete
        client.delete("/linked-content/delete/#{id}")
      end

      # Transcribes a linked content.
      # @return [Swiftner::API::LinkedContent]
      def transcribe
        response = client.post(
          "/linked-content/transcribe/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        @details = @details.merge(response.parsed_response)

        self
      end
    end
  end
end
