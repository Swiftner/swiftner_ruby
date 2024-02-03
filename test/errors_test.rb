# frozen_string_literal: true

require "test_helper"

module Swiftner
  class ErrorsTest < Minitest::Test
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
end
