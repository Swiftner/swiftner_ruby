# frozen_string_literal: true

module Swiftner
  module API
    # The `Service` class acts as a base class for API operations and data encapsulation.
    class Service
      attr_reader :id, :details, :client

      def self.build(details)
        new(details)
      end

      def initialize(attributes = {}, client = Base.client)
        @id = attributes["id"]
        @details = attributes
        @client = client
      end
    end
  end
end
