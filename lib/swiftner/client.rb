# frozen_string_literal: true

require "httparty"

module Swiftner
  # Initializes a new instance of the Client class.
  #
  # @param api_key [String] The API key to be used for authentication.
  class Client
    include HTTParty
    base_uri "https://api.swiftner.com"

    def initialize(api_key)
      self.class.headers "Api_Key_Header" => api_key
    end

    %i[get post put delete].each do |http_method|
      define_method(http_method) do |path, options = {}|
        response = self.class.public_send(http_method, path, options)
        handle_response(response)
      end
    end

    def check_health
      get("/health")
    end

    private

    def handle_response(response)
      case response.code
      when 200 then response
      when 401 then raise Unauthorized
      when 403 then raise Forbidden
      when 404 then raise NotFound
      when 500 then raise InternalError
      else raise Error, "Unknown error occurred"
      end
    end
  end
end
