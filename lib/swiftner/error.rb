# frozen_string_literal: true

module Swiftner
  # Encapsulates all errors that can be raised by the Swiftner API
  class Error < StandardError
    attr_reader :response

    def self.from_response(response)
      return new(response["detail"], response: response) if response.key?("detail")

      new(response.to_s, response: response)
    end

    def initialize(message, response: nil)
      @response = response
      super(message)
    end
  end

  class Forbidden < Error; end
  class Unauthorized < Error; end
  class NotFound < Error; end
  class InternalError < Error; end
end
