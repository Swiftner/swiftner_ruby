# frozen_string_literal: true

require "test_helper"

class LinkedContentTest < Minitest::Test
  def setup
    @linked_content_service = Swiftner::API::LinkedContent
    create_and_stub_client
  end

  # rubocop:disable Layout/LineLength
  def stub_api_requests(api_key = "swiftner-api-key")
    stub_get("https://api.swiftner.com/linked-content/get-all/", [{ id: 1, type: "linked_content" }].to_json, api_key)
    stub_get("https://api.swiftner.com/linked-content/get/1", { id: 1, type: "linked_content" }.to_json, api_key)
    stub_post("https://api.swiftner.com/linked-content/create", api_key)
    stub_post("https://api.swiftner.com/linked-content/batch-create", api_key)
    stub_put("https://api.swiftner.com/linked-content/update/1", api_key)
    stub_delete("https://api.swiftner.com/linked-content/delete/1", api_key)
    stub_get("https://api.swiftner.com/linked-content/get/1/transcriptions", [{ id: 1, language: "en" }].to_json, api_key)
    stub_post("https://api.swiftner.com/linked-content/transcribe/1", api_key)
  end
  # rubocop:enable Layout/LineLength

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

  def test_delete_linked_content
    linked_content = @linked_content_service.find(1)
    response = linked_content.delete
    assert_equal "success", response["status"]
  end

  def test_transcribe_linked_content
    linked_content = @linked_content_service.find(1)
    response = linked_content.transcribe
    assert response.is_a?(Swiftner::API::LinkedContent)
    assert_equal 1, response.id
    assert response.transcriptions.is_a?(Array)
    assert response.transcriptions.first.is_a?(Swiftner::API::Transcription)
  end

  private

  def sample_attributes
    {
      title: "Sample title",
      url: "url",
      meta: {}
    }
  end
end
