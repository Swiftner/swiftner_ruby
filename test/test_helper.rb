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
  base_url = "https://api.swiftner.com"

  stub_get("#{base_url}/health", { status: "ok" }.to_json, api_key)

  stub_crud("video-content", { id: 1, media_type: "video" }, api_key, "get-all")

  stub_crud("linked-content", { id: 1, type: "linked_content", url: "https://youtube.com" }, api_key, "get-all")
  stub_post("https://api.swiftner.com/linked-content/batch-create", api_key)
  stub_get("https://api.swiftner.com/linked-content/get/1/transcriptions", [{ id: 1, language: "en" }].to_json, api_key)
  stub_post("https://api.swiftner.com/linked-content/transcribe/1", api_key)

  stub_crud("space", { id: 1, name: "test", description: "test" }, api_key)

  stub_crud("chapter", { id: 1, title: "test", start: "2024-09-09T00:00:00", duration: "2024-09-09T00:00:02", video_content_id: 1 }, api_key)

  stub_crud("organisation", { id: 1, name: "test", description: "test" }, api_key, "get-current-user-orgs")
  stub_put_body("https://api.swiftner.com/organisation/add-org-to-token?organisation_id=1", { "access_token" => "eyekljsadflkajdfs" }.to_json, api_key)

  stub_crud("channel", { id: 1, name: "test", type: "audio", space_id: 1 }, api_key)
  stub_get("https://api.swiftner.com/channel/is_channel_live?channel_id=1", { "status" => "live" }.to_json, api_key)

  stub_crud("meeting", { id: 1, language: "no", space_id: 1, space: 1, state: "not_started" }, api_key)
  stub_post_body("https://api.swiftner.com/meeting/1/start", { id: 1, language: "no", space_id: 1, space: 1, state: "ongoing" }.to_json, api_key)
  stub_post_body("https://api.swiftner.com/meeting/1/pause", { id: 2, language: "no", space_id: 1, space: 1, state: "paused" }.to_json, api_key)
  stub_post_body("https://api.swiftner.com/meeting/1/end", { id: 2, language: "no", space_id: 1, space: 1, state: "ended" }.to_json, api_key)
  stub_post_body("https://api.swiftner.com/meeting/1/resume", { id: 3, language: "no", space_id: 1, space: 1, state: "ongoing" }.to_json, api_key)

  stub_crud("upload", { id: 1, media_type: "video" }, api_key)
  stub_post("https://api.swiftner.com/transcription/create", api_key)
  stub_get("https://api.swiftner.com/upload/get/1/transcriptions", [{ id: 1, language: "en" }].to_json, api_key)
end

def stub_crud(service_name, return_body, api_key, all_path = "get-#{service_name}s")
  base_url = "https://api.swiftner.com"

  stub_get("#{base_url}/#{service_name}/#{all_path}", [return_body].to_json, api_key)
  stub_get("#{base_url}/#{service_name}/get/1", return_body.to_json, api_key)
  stub_post("#{base_url}/#{service_name}/create", api_key)
  stub_put("#{base_url}/#{service_name}/update/1", api_key)
  stub_delete("#{base_url}/#{service_name}/delete/1", api_key)
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

def stub_put_body(url, return_body, api_key)
  stub_request(:put, url)
    .with(headers: { "Api_Key_Header" => api_key })
    .to_return(
      status: 200,
      body: return_body,
      headers: { "Content-Type" => "application/json" }
    )
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
