# frozen_string_literal: true

require_relative "swiftner/version"
require "httparty"

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
      self.class.headers "api_key" => api_key
    end

    def check_health
      self.class.get("/health")
    end

    def get(path, options = {})
      self.class.get(path, options)
    end

    def post(path, options = {})
      self.class.post(path, options)
    end

    def put(path, options = {})
      self.class.put(path, options)
    end

    def delete(path, options = {})
      self.class.delete(path, options)
    end
  end

  ### API
  module API
    class Service
      attr_reader :id, :details, :client

      def self.build(details)
        new(details["id"], details)
      end

      def initialize(id, details, client = Base.client)
        @id = id
        @client = client
        @details = details
      end
    end

    ### Transcription
    class Transcription < Service
      def self.find(transcription_id)
        response = Base.client.get("/transcription/get/#{transcription_id}")
        build(response)
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
        build(response)
      end

      def transcriptions
        response = client.get("/upload/get/#{id}/transcriptions")
        response.map { |transcription| API::Transcription.build(transcription) }
      end
    end
  end
end
