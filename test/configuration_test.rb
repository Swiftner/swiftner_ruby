# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  def setup
    @config = Swiftner::Configuration.new
  end

  def test_initialization
    assert_nil @config.client, "Client should be nil upon initialization"
  end

  def test_client_assignment
    fake_client = Object.new
    @config.client = fake_client
    assert_equal fake_client, @config.client, "Client should be assignable"
  end
end
