# frozen_string_literal: true

require "test_helper"

module Swiftner
  class UploadTest < Minitest::Test
    include StubApiHelper

    def setup
      api_key = "your_api_key"
      @client = Swiftner::Client.new(api_key)
      Swiftner::Base.client = @client
      @upload_service = Swiftner::API::Upload

      stub_api("https://api.swiftner.com/upload/get-uploads/",
               [{ id: 1, media_type: "video" }].to_json,
               api_key)

      stub_api("https://api.swiftner.com/upload/get/1",
               { id: 1, media_type: "video" }.to_json,
               api_key)
    end

    def test_get_uploads
      uploads = @upload_service.find_uploads
      assert uploads.is_a?(Array)
      assert uploads.first.is_a?(Swiftner::API::Upload)
    end

    def test_get_upload
      upload = @upload_service.find(1)
      assert upload.is_a?(Swiftner::API::Upload)
      assert_equal 1, upload.id
    end
  end
end
