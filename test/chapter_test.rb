# frozen_string_literal: true

require "test_helper"

class ChapterTest < Minitest::Test
  def setup
    @chapter_service = Swiftner::API::Chapter
    create_and_stub_client
  end

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
