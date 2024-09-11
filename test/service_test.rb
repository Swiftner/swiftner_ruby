# frozen_string_literal: true

require "test_helper"

class ServiceTest < Minitest::Test
  def setup
    # Backup original Swiftner configuration
    @original_config = Swiftner.configuration.dup

    # Create a new configuration with no client
    Swiftner.configuration = Swiftner::Configuration.new

    @details = { "id" => "test_id", "key" => "value" }
  end

  def test_client_not_set
    assert_raises Swiftner::Error do
      Swiftner::API::Service.build(@details)
    end
  end

  def test_validate_required
    assert_raises ArgumentError do
      Swiftner::API::Service.validate_required({ name: "test" }, :name, :description)
    end
    assert_raises ArgumentError do
      Swiftner::API::Service.validate_required({ name: "test", surname: "test" }, %i[name surname], %i[hello world])
    end

    assert_silent do
      Swiftner::API::Service.validate_required({ name: "test", description: "description text" }, :name, :description)
      Swiftner::API::Service.validate_required({ name: "test" }, %i[name surname])
    end
  end

  def test_validate_language
    assert_raises ArgumentError do
      Swiftner::API::Service.validate_language({ language: "gibberish" })
    end

    assert_silent do
      Swiftner::API::Service.validate_language({ language: "no" })
    end
  end

  def teardown
    # Restore original Swiftner configuration
    Swiftner.configuration = @original_config
  end
end
