# frozen_string_literal: true

require "minitest/autorun"
require "webmock/minitest"
require_relative "../lib/swiftner" # Adjust path as necessary

class UploadTest < Minitest::Test
  def setup
    api_key = "your_api_key"
    @client = Swiftner::Client.new(api_key)
    Swiftner::Base.client = @client
    @upload_service = Swiftner::API::Upload

    stub_request(:get, "https://api.swiftner.com/upload/get-uploads/")
      .with(headers: { "Api_Key_Header" => api_key })
      .to_return(
        status: 200,
        body: [{ id: 1, media_type: "video" }].to_json,
        headers: { "Content-Type" => "application/json" }
      )

    stub_request(:get, "https://api.swiftner.com/upload/get/1")
      .with(headers: { "Api_Key_Header" => api_key })
      .to_return(
        status: 200,
        body: { id: 1, media_type: "video" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
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
