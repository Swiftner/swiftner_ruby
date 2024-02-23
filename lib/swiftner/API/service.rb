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

      def initialize(attributes = {}, client = self.class.client)
        raise Swiftner::Error, "Client must be set" if client.nil?

        @id = attributes["id"]
        @details = attributes
        @client = client
      end
    end
  end
end
