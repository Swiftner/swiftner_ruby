# frozen_string_literal: true

require "test_helper"

class LinkedContentTest < Minitest::Test
  def setup
    @linked_content_service = Swiftner::API::LinkedContent
    create_and_stub_client
  end

  def test_find_linked_contents
    linked_contents = @linked_content_service.find_linked_contents
    assert linked_contents.is_a?(Array)
    assert linked_contents.first.is_a?(Swiftner::API::LinkedContent)
  end

  def test_find_linked_content
    linked_content = @linked_content_service.find(1)
    assert linked_content.is_a?(Swiftner::API::LinkedContent)
    assert_equal 1, linked_content.id
  end

  def test_create_linked_content
    linked_content = @linked_content_service.create(sample_attributes)
    assert linked_content.is_a?(Swiftner::API::LinkedContent)
    refute_nil linked_content.id
    assert_equal "Sample title", linked_content.details["title"]
  end

  def test_batch_create_linked_content
    linked_contents = @linked_content_service.batch_create([sample_attributes])
    assert linked_contents.is_a?(Array)
  end

  def test_update_linked_content
    linked_content = @linked_content_service.find(1)
    linked_content.update(title: "New title")
    assert_equal "New title", linked_content.details["title"]
    assert_equal 1, linked_content.id
  end

  def test_linked_content_transcriptions
    linked_content = @linked_content_service.find(1)
    transcriptions = linked_content.transcriptions
    assert transcriptions.is_a?(Array)
    assert transcriptions.first.is_a?(Swiftner::API::Transcription)
  end

  private

  def sample_attributes
    {
      title: "Sample title",
      description: "Sample description",
      start: "2024-02-03T12:29:07.142Z",
      language: "en",
      url: "url",
      thumbnail_url: "sample/thumbnail_url",
      audio_url: "sample/audio_url",
      duration: 0,
      meta: {}
    }
  end
end
