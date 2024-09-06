# frozen_string_literal: true

module Swiftner
  module API
    # Represents a Meeting service responsible for finding, creating, and deleting spaces.
    # Inherits from the Service class.
    # Provides methods for interacting with meetings.
    class Meeting < Service
      REQUIRED_ATTRIBUTES = %i[space_id language].freeze
      # Finds all meetings
      # @return [Array<Swiftner::API::Meeting>]
      def self.find_meetings
        response = client.get("/meeting/get-meetings")
        map_collection(response)
      end

      # Finds meeting by id
      # @param [Integer] meeting_id
      # @return [Swiftner::API::Meeting]
      def self.find(meeting_id)
        response = client.get("/meeting/get/#{meeting_id}")
        build(response.parsed_response)
      end

      # Creates a meeting.
      # @param [Hash] attributes
      # @option attributes [Integer] :space_id (required)
      # @option attributes [String] :language (required)
      # @option attributes [String] :title (optional)
      # @option attributes [String] :description (optional)
      # @option attributes [String] :start (optional) eg. "2024-09-06T08:37:45.162Z"
      # @option attributes [Integer] :duration (optional)
      # @option attributes [String] :thumbnail_url (optional)
      # @option attributes [String] :state (optional) eg. "not_started", "ended"
      # @option attributes [Integer] :prompt_id (optional)
      # @return [Swiftner::API::Meeting]
      def self.create(attributes)
        validate_required(attributes, *REQUIRED_ATTRIBUTES)

        response = client.post(
          "/meeting/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      # Starts a meeting
      # @return [Swiftner::API::Meeting]
      def start
        if @details["state"] != "not_started"
          raise Swiftner::Error, "Meeting state must be 'not_started' to start the meeting."
        end

        response = client.post(
          "/meeting/#{id}/start",
          headers: { "Content-Type" => "application/json" }
        )

        @details = response
        self
      end

      # Ends a meeting
      # @return [Swiftner::API::Meeting]
      def end
        if (@details["state"] == "not_started") || (@details["state"] == "ended")
          raise Swiftner::Error, "Meeting state must be 'ongoing' or 'paused' to end the meeting."
        end

        response = client.post(
          "/meeting/#{id}/end",
          headers: { "Content-Type" => "application/json" }
        )
        @details = response
        self
      end

      # Pauses a meeting
      # @return [Swiftner::API::Meeting, nil]
      def pause
        raise Swiftner::Error, "Meeting state must be 'ongoing' to pause meeting." if @details["state"] != "ongoing"

        response = client.post(
          "/meeting/#{id}/pause",
          headers: { "Content-Type" => "application/json" }
        )
        @details = response
        self
      end

      # Resumes a meeting
      # @return [Swiftner::API::Meeting]
      def resume
        raise Swiftner::Error, "Meeting state must 'paused' to resume meeting." if @details["state"] != "paused"

        response = client.post(
          "/meeting/#{id}/resume",
          headers: { "Content-Type" => "application/json" }
        )
        @details = response
        self
      end

      # Updates a meeting.
      # @param [Hash] attributes
      # @option attributes [Integer] :space_id (optional)
      # @option attributes [String] :language (optional) eg. "no", "en"
      # @option attributes [String] :title (optional)
      # @option attributes [String] :description (optional)
      # @option attributes [String] :start (optional) eg. "2024-09-06T08:37:45.162Z"
      # @option attributes [Integer] :duration (optional)
      # @option attributes [String] :thumbnail_url (optional)
      # @option attributes [String] :state (optional) eg. "not_started", "ended"
      # @option attributes [Integer] :prompt_id (optional)
      # @return [Swiftner::API::Meeting]
      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)

        self.class.validate_required(@details, :language, :space)

        client.put(
          "/meeting/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end

      # Deletes a meeting.
      # @return [Hash]
      def delete
        client.delete("/meeting/delete/#{id}")
      end
    end
  end
end
