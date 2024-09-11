# frozen_string_literal: true

require "test_helper"

class RecordingTest < Minitest::Test
  def setup
    @recording_service = Swiftner::API::Recording
    create_and_stub_client
  end

  def test_find_recordings
    recordings = @recording_service.find_recordings
    assert recordings.is_a?(Array)
    assert recordings.first.is_a?(Swiftner::API::Recording)
  end

  def test_find_recording
    recording = @recording_service.find(1)
    assert recording.is_a?(Swiftner::API::Recording)
    assert_equal 1, recording.id
  end

  def test_create_recording
    recording = @recording_service.create({ start: "2024-09-11T06:39:09.301923", path: "https://youtube.com", channel_id: 1, meeting_id: 1, title: "New recording" })
    assert recording.is_a?(Swiftner::API::Recording)
    refute_nil recording.id
    assert_equal "New recording", recording.details["title"]
  end

  def test_update_recording
    recording = @recording_service.find(1)
    recording.update(title: "New title")
    assert_equal "New title", recording.details["title"]
    assert_equal 1, recording.id
  end

  def test_delete_recording
    recording = @recording_service.find(1)
    response = recording.delete
    assert_equal "success", response["status"]
  end
end
