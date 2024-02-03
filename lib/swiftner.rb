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
    Base.client = Client.new(api_key)
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

    %i[get post put delete].each do |http_method|
      define_method(http_method) do |path, options = {}|
        response = self.class.public_send(http_method, build_path(path), options)
        handle_response(response)
      end
    end

    def check_health
      get("/health")
    end

    private

    def build_path(path)
      # This is temporary solution because server doesn't accept the API Key in headers for some reason.
      "#{path}?api_key_query=#{ENV.fetch("SWIFTNER_API_KEY", "swiftner-api-key")}"
    end

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

    ### VideoContent
    class VideoContent < Service
      def self.find_video_contents
        response = Base.client.get("/video-content/get-all/")
        response.map { |upload| build(upload) }
      end

      def self.find(id)
        response = Base.client.get("/video-content/get/#{id}")
        build(response.parsed_response)
      end

      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)

        client.put(
          "/video-content/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end
    end
  end
end
