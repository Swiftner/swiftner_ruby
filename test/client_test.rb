# frozen_string_literal: true

require "test_helper"

class ClientTest < Minitest::Test
  def setup
    create_and_stub_client
  end

  def test_check_health
    response = @client.check_health
    assert_equal "ok", response.parsed_response["status"]
  end
end
