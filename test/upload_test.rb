# frozen_string_literal: true

require "test_helper"

module Swiftner
  class UploadTest < Minitest::Test
    include StubApiHelper

    API_KEY = "your_api_key"

    def setup
      @upload_service = Swiftner::API::Upload
      create_and_stub_client
      stub_requests
    end

    def create_and_stub_client
      @client = Swiftner::Client.new(API_KEY)
      Swiftner::Base.client = @client
    end

    def stub_requests
      stub_get("https://api.swiftner.com/upload/get-uploads/", [{ id: 1, media_type: "video" }].to_json, API_KEY)
      stub_get("https://api.swiftner.com/upload/get/1", { id: 1, media_type: "video" }.to_json, API_KEY)
      stub_post("https://api.swiftner.com/upload/create", API_KEY)
      stub_delete("https://api.swiftner.com/upload/delete/1", API_KEY)
      stub_post("https://api.swiftner.com/transcription/create", API_KEY)
      stub_get("https://api.swiftner.com/upload/get/1/transcriptions", [{ id: 1, language: "en" }].to_json, API_KEY)
    end

    def test_find_uploads
      uploads = @upload_service.find_uploads
      assert uploads.is_a?(Array)
      assert uploads.first.is_a?(Swiftner::API::Upload)
    end

    def test_find_upload
      upload = @upload_service.find(1)
      assert upload.is_a?(Swiftner::API::Upload)
      assert_equal 1, upload.id
    end

    def test_create_upload
      upload = @upload_service.create(sample_attributes)
      assert upload.is_a?(Swiftner::API::Upload)
      refute_nil upload.id
      assert_equal "Sample title", upload.details["title"]
    end

    def test_delete_upload
      upload = @upload_service.find(1)
      response = upload.delete
      assert_equal "success", response["status"]
    end

    def test_upload_transcriptions
      upload = @upload_service.find(1)
      transcriptions = upload.transcriptions
      assert transcriptions.is_a?(Array)
      assert transcriptions.first.is_a?(Swiftner::API::Transcription)
    end

    def test_transcribe_upload
      upload = @upload_service.find(1)
      transcription = upload.transcribe("no")
      assert transcription.is_a?(Swiftner::API::Transcription)
    end

    private

    def sample_attributes
      {
        title: "Sample title",
        description: "Sample description",
        start: "2024-02-03T12:29:07.142Z",
        language: "en",
        path: "sample/path",
        thumbnail_url: "sample/thumbnail_url",
        audio_url: "sample/audio_url"
      }
    end
  end
end
