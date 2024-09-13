# frozen_string_literal: true

require "test_helper"

class SegmentTest < Minitest::Test
  def setup
    @segment_service = Swiftner::API::Segment
    create_and_stub_client
  end

  def test_find_segments
    segments = @segment_service.find_segments(1)
    assert segments.is_a?(Array)
    assert segments.first.is_a?(Swiftner::API::Segment)
  end

  def test_find_segment
    segment = @segment_service.find(1)
    assert segment.is_a?(Swiftner::API::Segment)
    assert_equal 1, segment.id
  end

  def test_create_segment
    segment = @segment_service.create({ text: "New Segment", language: "en", video_start: 1, start: 1.0, end: 2.0, transcription_id: 1, words: [{ word: "hello", start: 1.0, end: 1.5, probability: 0.9 }] })
    assert segment.is_a?(Swiftner::API::Segment)
    refute_nil segment.id
    assert_equal "New Segment", segment.details["text"]
  end

  def test_update_segment
    segment = @segment_service.find(1)
    segment.update(text: "New text")
    assert_equal "New text", segment.details["text"]
    assert_equal 1, segment.id
  end

  def test_delete_space
    segment = @segment_service.find(1)
    response = segment.delete
    assert_equal "success", response["status"]
  end
end
