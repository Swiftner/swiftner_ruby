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

# rubocop:disable Metrics/AbcSize,Metrics/MethodLength
def stub_api_requests(api_key)
  stub_get("https://api.swiftner.com/upload/get-uploads/", [{ id: 1, media_type: "video" }].to_json, api_key)
  stub_get("https://api.swiftner.com/upload/get/1", { id: 1, media_type: "video" }.to_json, api_key)
  stub_post("https://api.swiftner.com/upload/create", api_key)
  stub_delete("https://api.swiftner.com/upload/delete/1", api_key)
  stub_post("https://api.swiftner.com/transcription/create", api_key)
  stub_get("https://api.swiftner.com/upload/get/1/transcriptions", [{ id: 1, language: "en" }].to_json, api_key)
  stub_get("https://api.swiftner.com/health", { status: "ok" }.to_json, api_key)
  stub_get("https://api.swiftner.com/video-content/get-all/", [{ id: 1, media_type: "video" }].to_json, api_key)
  stub_get("https://api.swiftner.com/video-content/get/1", { id: 1, media_type: "video" }.to_json, api_key)
  stub_put("https://api.swiftner.com/video-content/update/1", api_key)

  stub_get("https://api.swiftner.com/linked-content/get-all/", [{ id: 1, type: "linked_content" }].to_json, api_key)
  stub_get("https://api.swiftner.com/linked-content/get/1", { id: 1, type: "linked_content" }.to_json, api_key)
  stub_post("https://api.swiftner.com/linked-content/create", api_key)
  stub_post("https://api.swiftner.com/linked-content/batch-create", api_key)
  stub_put("https://api.swiftner.com/linked-content/update/1", api_key)
  stub_get("https://api.swiftner.com/linked-content/get/1/transcriptions", [{ id: 1, language: "en" }].to_json, api_key)

  stub_get("https://api.swiftner.com/space/get-spaces", [{ id: 1, name: "test", description: "test" }].to_json, api_key)
  stub_get("https://api.swiftner.com/space/get/1", { id: 1, name: "test", description: "test" }.to_json, api_key)
  stub_post("https://api.swiftner.com/space/create", api_key)
  stub_put("https://api.swiftner.com/space/update/1", api_key)
  stub_delete("https://api.swiftner.com/space/delete/1", api_key)
end
# rubocop:enable Metrics/AbcSize,Metrics/MethodLength

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
    persisted_body = JSON.parse(request.body)

    if persisted_body.is_a?(Array)
      persisted_body.map { |item| item["id"] = 1 }
    else
      persisted_body["id"] = 1
    end

    { status: 200, body: persisted_body.to_json, headers: { "Content-Type" => "application/json" } }
  end
end

def stub_put(url, api_key)
  stub_request(:put, url)
    .with(headers: { "Api_Key_Header" => api_key })
    .to_return do |request|
    persisted_body = JSON.parse(request.body)
    persisted_body.is_a?(Array) ? persisted_body.map { |i| i["id"] = 1 } :
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
