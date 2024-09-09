# frozen_string_literal: true

require "test_helper"

class ChapterTest < Minitest::Test
  def setup
    @chapter_service = Swiftner::API::Chapter
    create_and_stub_client
  end

  # rubocop:disable Layout/LineLength
  def stub_api_requests(api_key = "swiftner-api-key")
    stub_get("https://api.swiftner.com/video-content/get/1/chapters", [{ id: 1, title: "test", start: "2024-09-09T00:00:00", duration: "2024-09-09T00:00:02", video_content_id: 1 }].to_json, api_key)
    stub_get("https://api.swiftner.com/chapter/get/1", { id: 1, title: "test", start: "2024-09-09T00:00:00", duration: "2024-09-09T00:00:02", video_content_id: 1 }.to_json, api_key)
    stub_post("https://api.swiftner.com/chapter/create", api_key)
    stub_put("https://api.swiftner.com/chapter/update/1", api_key)
    stub_delete("https://api.swiftner.com/chapter/delete/1", api_key)
  end
  # rubocop:enable Layout/LineLength

  def test_find_chapters
    chapters = @chapter_service.find_chapters(1)
    assert chapters.is_a?(Array)
    assert chapters.first.is_a?(Swiftner::API::Chapter)
  end

  def test_find_chapter
    chapter = @chapter_service.find(1)
    assert chapter.is_a?(Swiftner::API::Chapter)
    assert_equal 1, chapter.id
  end

  def test_create_chapter
    chapter = @chapter_service.create({ title: "New chapter", start: "2025", duration: "10", video_content_id: 1 })
    assert chapter.is_a?(Swiftner::API::Chapter)
    refute_nil chapter.id
    assert_equal "New chapter", chapter.details["title"]
  end

  def test_update_chapter
    chapter = @chapter_service.find(1)
    chapter.update(title: "New title")
    assert_equal "New title", chapter.details["title"]
    assert_equal 1, chapter.id
  end

  def test_delete_chapter
    chapter = @chapter_service.find(1)
    response = chapter.delete
    assert_equal "success", response["status"]
  end
end
