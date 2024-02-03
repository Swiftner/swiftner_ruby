# frozen_string_literal: true

require "minitest/autorun"
require "webmock/minitest"
require_relative "../lib/swiftner"

module Swiftner
  class ClientTest < Minitest::Test
    def setup
      @api_key = "your_api_key"
      @client = Swiftner::Client.new(@api_key)
      stub_request(:get, "https://api.swiftner.com/health")
        .with(headers: { "Api_Key_Header" => @api_key })
        .to_return(
          status: 200,
          body: { status: "ok" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    def test_check_health
      response = @client.check_health
      assert_equal "ok", response.parsed_response["status"]
    end
  end
end
