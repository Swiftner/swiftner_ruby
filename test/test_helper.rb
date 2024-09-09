# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "swiftner"

require "minitest/autorun"
require "webmock/minitest"

def create_and_stub_client(api_key = "swiftner-api-key")
  Swiftner.configure do |config|
    config.client = Swiftner::Client.new(api_key)
  end

  @client = Swiftner.configuration.client
  stub_api_requests(api_key)
end

def stub_api_requests(api_key)
  stub_get("https://api.swiftner.com/health", { status: "ok" }.to_json, api_key)
end

def stub_get(url, return_body, api_key)
  stub_request(:get, url)
    .with(headers: { "Api_Key_Header" => api_key })
    .to_return(
      status: 200,
      body: return_body,
      headers: { "Content-Type" => "application/json" }
    )
end

def stub_post(url, api_key)
  stub_request(:post, url)
    .with(headers: { "Api_Key_Header" => api_key })
    .to_return do |request|
    persisted_body = parse_body(request.body)

    { status: 200, body: persisted_body.to_json, headers: { "Content-Type" => "application/json" } }
  end
end

def stub_post_body(url, return_body, api_key)
  stub_request(:post, url)
    .with(headers: { "Api_Key_Header" => api_key })
    .to_return(
      status: 200,
      body: return_body,
      headers: { "Content-Type" => "application/json" }
    )
end

def stub_put(url, api_key)
  stub_request(:put, url)
    .with(headers: { "Api_Key_Header" => api_key })
    .to_return do |request|
    persisted_body = parse_body(request.body)
    { status: 200, body: persisted_body.to_json, headers: { "Content-Type" => "application/json" } }
  end
end

def stub_delete(url, api_key)
  stub_request(:delete, url)
    .with(headers: { "Api_Key_Header" => api_key })
    .to_return(
      status: 200,
      body: { status: "success" }.to_json,
      headers: { "Content-Type" => "application/json" }
    )
end

def parse_body(body)
  persisted_body = JSON.parse(body)
  if persisted_body.is_a?(Array)
    persisted_body.map { |item| item["id"] = 1 }
  else
    persisted_body["id"] = 1
  end
  persisted_body
end
