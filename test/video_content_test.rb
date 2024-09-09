# frozen_string_literal: true

require "test_helper"

class VideoContentTest < Minitest::Test
  def setup
    @video_content_service = Swiftner::API::VideoContent
    create_and_stub_client
  end

  def stub_api_requests(api_key = "swiftner-api-key")
    stub_get("https://api.swiftner.com/video-content/get-all/", [{ id: 1, media_type: "video" }].to_json, api_key)
    stub_get("https://api.swiftner.com/video-content/get/1", { id: 1, media_type: "video" }.to_json, api_key)
    stub_put("https://api.swiftner.com/video-content/update/1", api_key)
  end

  def test_find_video_contents
    video_contents = @video_content_service.find_video_contents
    assert video_contents.is_a?(Array)
    assert video_contents.first.is_a?(Swiftner::API::VideoContent)
  end

  def test_find_video_content
    video_content = @video_content_service.find(1)
    assert video_content.is_a?(Swiftner::API::VideoContent)
    assert_equal 1, video_content.id
  end

  def test_update_video_content
    video_content = @video_content_service.find(1)
    video_content.update(title: "New title")
    assert_equal "New title", video_content.details["title"]
    assert_equal 1, video_content.id
  end
end
