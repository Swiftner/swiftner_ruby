# frozen_string_literal: true

module Swiftner
  module API
    # Represents a Space service responsible for finding, creating, and deleting spaces.
    # Inherits from the Service class.
    # Provides methods for interacting with spaces.
    class Organisation < Service
      def self.create(attributes)
        validate_required(attributes, :name, :description)
        response = client.post(
          "/organisation/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        build(response.parsed_response)
      end
    end
  end
end
