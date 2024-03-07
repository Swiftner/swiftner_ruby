# frozen_string_literal: true

require "test_helper"

class ErrorsTest < Minitest::Test
  def test_creating_error_from_response_with_detail
    response = { "detail" => "You are not authorized" }
    error = Swiftner::Error.from_response(response)

    assert_equal "You are not authorized", error.message
    assert_equal response, error.response
  end

  def test_creating_error_from_response_without_detail
    response = { "err" => "a" }
    error = Swiftner::Error.from_response(response)

    assert_equal "{\"err\"=>\"a\"}", error.message
    assert_equal response, error.response
  end

  def test_error_inheritance
    assert Swiftner::Error < StandardError
  end

  def test_forbidden_inheritance
    assert Swiftner::Forbidden < Swiftner::Error
  end

  def test_unauthorized_inheritance
    assert Swiftner::Unauthorized < Swiftner::Error
  end

  def test_not_found_inheritance
    assert Swiftner::NotFound < Swiftner::Error
  end

  def test_internal_error_inheritance
    assert Swiftner::InternalError < Swiftner::Error
  end
end
