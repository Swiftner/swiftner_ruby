# frozen_string_literal: true

module Swiftner
  ## `Swiftner::Configuration`
  class Configuration
    SUPPORTED_LANGUAGES = %w[en no].freeze
    attr_reader :client

    def initialize
      @client = nil
    end

    def client=(client)
      @client = client
      @accepted_file_types = fetch_accepted_file_types
    end

    def fetch_accepted_file_types
      # ! /upload/accepted_file_types gives 401 Unauthorized with good API key
      # ! should be fixed soon
      # response = @client.get("/upload/accepted_file_types")
      # @accepted_file_types = handle_response(response).parsed_response
      # rescue Unauthorized => e
      #   puts "Authentication failed. Please check your API key."
      #   raise e
      @accepted_file_types = {
        video: %w[mp4 mkv mov avi flv wmv webm],
        audio: %w[mp3 wav wma m4v]
      }
    end

  end
end
