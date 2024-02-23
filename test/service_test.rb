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

  def teardown
    # Restore original Swiftner configuration
    Swiftner.configuration = @original_config
  end
end
