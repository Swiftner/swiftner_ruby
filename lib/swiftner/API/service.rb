# frozen_string_literal: true

module Swiftner
  module API
    # The `Service` class acts as a base class for API operations and data encapsulation.
    class Service
      attr_reader :id, :details, :client

      def self.build(details)
        new(details)
      end

      def self.client
        Swiftner.configuration.client
      end

      def self.validate_required(attributes, *keys)
        attr_str_keys = attributes.transform_keys(&:to_s)
        missing_keys = keys.map(&:to_s).reject { |key| attr_str_keys.key?(key) }

        return unless missing_keys.any?

        raise ArgumentError, "Key(s) '#{missing_keys.join(", ")}' are missing in attributes. #{attributes.inspect}"
      end

      def self.map_collection(response)
        response.map { |item| build(item) }
      end

      def initialize(attributes = {}, client = self.class.client)
        raise Swiftner::Error, "Client must be set" if client.nil?

        @id = attributes["id"]
        @details = attributes
        @client = client
      end
    end
  end
end
