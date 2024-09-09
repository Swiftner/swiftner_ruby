# frozen_string_literal: true

require "test_helper"

class MeetingTest < Minitest::Test
  def setup
    @meeting_service = Swiftner::API::Meeting
    create_and_stub_client
  end

  def test_find_meetings
    meetings = @meeting_service.find_meetings
    assert meetings.is_a?(Array)
    assert meetings.first.is_a?(Swiftner::API::Meeting)
  end

  def test_find_meeting
    meeting = @meeting_service.find(1)
    assert meeting.is_a?(Swiftner::API::Meeting)
    assert_equal 1, meeting.id
  end

  def test_create_meeting
    meeting = @meeting_service.create({ space_id: 1, language: "en", title: "New meeting" })
    assert meeting.is_a?(Swiftner::API::Meeting)
    refute_nil meeting.id
    assert_equal "New meeting", meeting.details["title"]
  end

  def test_start_meeting
    meeting = @meeting_service.find(1)
    assert_equal "not_started", meeting.details["state"]
    meeting.start
    assert_equal "ongoing", meeting.details["state"]
  end

  def test_end_meeting
    meeting = @meeting_service.find(2)
    assert_equal "ongoing", meeting.details["state"]
    meeting.end
    assert_equal "ended", meeting.details["state"]
  end

  def test_pause_meeting
    meeting = @meeting_service.find(2)
    assert_equal "ongoing", meeting.details["state"]
    meeting.pause
    assert_equal "paused", meeting.details["state"]
  end

  def test_resume_meeting
    meeting = @meeting_service.find(3)
    assert_equal "paused", meeting.details["state"]
    meeting.resume
    assert_equal "ongoing", meeting.details["state"]
  end

  def test_update_meeting
    meeting = @meeting_service.find(1)
    meeting.update(title: "Updated title")
    assert_equal "Updated title", meeting.details["title"]
    assert_equal 1, meeting.id
  end

  def test_delete_meeting
    meeting = @meeting_service.find(1)
    response = meeting.delete
    assert_equal "success", response["status"]
  end
end
