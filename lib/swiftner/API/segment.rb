# frozen_string_literal: true

module Swiftner
  module API
    # Represents a Segment service responsible for finding, creating, and deleting segments.
    # Inherits from the Service class.
    # Provides methods for interacting with segments.
    class Segment < Service
      REQUIRED_ATTRIBUTES = %i[text language video_start start end transcription_id].freeze
      # Finds all segments for a transcription.
      # @param [Integer] transcription_id
      # @return [Array<Swiftner::API::Segment>]
      def self.find_segments(transcription_id)
        response = client.get("/transcription/get/#{transcription_id}/segments")
        map_collection(response)
      end

      # Finds segment by id.
      # @param [Integer] segment_id
      # @return [Swiftner::API::Segment]
      def self.find(segment_id)
        response = client.get("/segment/get/#{segment_id}")
        build(response.parsed_response)
      end

      # Creates a segment.
      # @param [Hash] attributes
      # @option attributes [String] :text (required)
      # @option attributes [String] :language (required)
      # @option attributes [Integer] :video_start (required)
      # @option attributes [Float] :start (required)
      # @option attributes [Float] :end (required)
      # @option attributes [String] :transcription_id (required)
      # @option attributes [Array<Hash>] :words (required)
      # @option words [String] :word (required)
      # @option words [Float] :start (required)
      # @option words [Float] :end (required)
      # @option words [Integer] :probability (optional)
      # @option attributes [String] :order (optional)
      # @return [Swiftner::API::Segment]
      def self.create(attributes)
        validate_required(attributes, *REQUIRED_ATTRIBUTES)
        validate_language(attributes)

        response = client.post(
          "/segment/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      # Deletes segment.
      # @return [Hash]
      def delete
        client.delete("/segment/delete/#{id}")
      end
    end
  end
end
