# frozen_string_literal: true

require_relative "swiftner/version"
require "httparty"

### Swiftner
module Swiftner
  class Error < StandardError; end
  class Forbidden < Error; end
  class Unauthorized < Error; end
  class NotFound < Error; end
  class InternalError < Error; end

  def self.create_client(api_key)
    client = Client.new(api_key)
    Base.client = client
    client
  end

  ### Base
  class Base
    @client = nil

    class << self
      attr_accessor :client
    end
  end

  ### Client
  class Client
    include HTTParty
    base_uri "https://api.swiftner.com"

    def initialize(api_key)
      self.class.headers "Api_Key_Header" => api_key
    end

    def check_health
      self.class.get("/health")
    end

    def get(path, options = {})
      self.class.get(build_path(path), options)
    end

    def post(path, options = {})
      self.class.post(build_path(path), options)
    end

    def put(path, options = {})
      self.class.put(build_path(path), options)
    end

    def delete(path, options = {})
      self.class.delete(build_path(path), options)
    end

    private

    def build_path(path)
      "#{path}?api_key_query=***REMOVED***"
    end
  end

  ### API
  module API
    ### Service
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

    ### Transcription
    class Transcription < Service
      def self.find(transcription_id)
        response = Base.client.get("/transcription/get/#{transcription_id}")
        build(response.parsed_response)
      end

      def self.create(attributes)
        response = Base.client.post(
          "/transcription/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      def delete
        client.delete("/transcription/delete/#{id}")
      end
    end

    ### Upload
    class Upload < Service
      def self.find_uploads
        response = Base.client.get("/upload/get-uploads/")
        response.map { |upload| build(upload) }
      end

      def self.find(upload_id)
        response = Base.client.get("/upload/get/#{upload_id}")
        build(response.parsed_response)
      end

      def self.create(attributes)
        response = Base.client.post(
          "/upload/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        build(response.parsed_response) if response.success?
      end

      def delete
        client.delete("/upload/delete/#{id}")
      end

      def transcriptions
        response = client.get("/upload/get/#{id}/transcriptions")
        response.map { |transcription| API::Transcription.build(transcription) }
      end

      def transcribe(language)
        transcription = {
          video_content_id: id,
          language: language,
          start: 0.0,
          end: details["duration"],
          duration: details["duration"]
        }
        API::Transcription.create(transcription)
      end
    end
  end
end
