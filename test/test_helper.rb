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
  stub_post_body("https://api.swiftner.com/video-content/create_editor_link/1", { url: "https://app.swiftner.com/editor/1/abcde-12345" }.to_json, api_key)

  stub_get("https://api.swiftner.com/linked-content/get-all/", [{ id: 1, type: "linked_content", url: "https://youtube.com" }].to_json, api_key)
  stub_get("https://api.swiftner.com/linked-content/get/1", { id: 1, type: "linked_content", url: "https://youtube.com" }.to_json, api_key)
  stub_post("https://api.swiftner.com/linked-content/create", api_key)
  stub_post("https://api.swiftner.com/linked-content/batch-create", api_key)
  stub_put("https://api.swiftner.com/linked-content/update/1", api_key)
  stub_delete("https://api.swiftner.com/linked-content/delete/1", api_key)
  stub_get("https://api.swiftner.com/linked-content/get/1/transcriptions", [{ id: 1, language: "en" }].to_json, api_key)
  stub_post("https://api.swiftner.com/linked-content/transcribe/1", api_key)

  stub_get("https://api.swiftner.com/space/get-spaces", [{ id: 1, name: "test", description: "test" }].to_json, api_key)
  stub_get("https://api.swiftner.com/space/get/1", { id: 1, name: "test", description: "test" }.to_json, api_key)
  stub_post("https://api.swiftner.com/space/create", api_key)
  stub_put("https://api.swiftner.com/space/update/1", api_key)
  stub_delete("https://api.swiftner.com/space/delete/1", api_key)

  stub_get("https://api.swiftner.com/video-content/get/1/chapters", [{ id: 1, title: "test", start: "2024-09-09T00:00:00", duration: "2024-09-09T00:00:02", video_content_id: 1 }].to_json, api_key)
  stub_get("https://api.swiftner.com/chapter/get/1", { id: 1, title: "test", start: "2024-09-09T00:00:00", duration: "2024-09-09T00:00:02", video_content_id: 1 }.to_json, api_key)
  stub_post("https://api.swiftner.com/chapter/create", api_key)
  stub_put("https://api.swiftner.com/chapter/update/1", api_key)
  stub_delete("https://api.swiftner.com/chapter/delete/1", api_key)

  stub_get("https://api.swiftner.com/organisation/get-current-user-orgs",
           [{ id: 1, name: "test", description: "test" }].to_json, api_key)
  stub_get("https://api.swiftner.com/organisation/get/1", { id: 1, name: "test", description: "test" }.to_json, api_key)
  stub_request(:put, "https://api.swiftner.com/organisation/add-org-to-token?organisation_id=1")
    .with(headers: { "Api_Key_Header" => api_key })
    .to_return do
    { status: 200, body: { "access_token" => "eyekljsadflkajdfs" }.to_json,
      headers: { "Content-Type" => "application/json" } }
  end
  stub_post("https://api.swiftner.com/organisation/create", api_key)
  stub_put("https://api.swiftner.com/organisation/update/1", api_key)
  stub_delete("https://api.swiftner.com/organisation/delete/1", api_key)

  stub_get("https://api.swiftner.com/channel/get-channels", [{ id: 1, name: "test", type: "audio", space_id: 1 }].to_json, api_key)
  stub_get("https://api.swiftner.com/channel/is_channel_live?channel_id=1", { "status" => "live" }.to_json, api_key)
  stub_get("https://api.swiftner.com/channel/get/1", { id: 1, name: "test", type: "audio", space_id: 1 }.to_json, api_key)
  stub_post("https://api.swiftner.com/channel/create", api_key)
  stub_put("https://api.swiftner.com/channel/update/1", api_key)
  stub_delete("https://api.swiftner.com/channel/delete/1", api_key)

  stub_get("https://api.swiftner.com/meeting/get-meetings", [{ id: 1, language: "no", space_id: 1 }].to_json, api_key)
  stub_get("https://api.swiftner.com/meeting/get/1", { id: 1, language: "no", space_id: 1, space: 1, state: "not_started" }.to_json, api_key)
  stub_get("https://api.swiftner.com/meeting/get/2", { id: 2, language: "no", space_id: 1, space: 1, state: "ongoing" }.to_json, api_key)
  stub_get("https://api.swiftner.com/meeting/get/3", { id: 3, language: "no", space_id: 1, space: 1, state: "paused" }.to_json, api_key)
  stub_post_body("https://api.swiftner.com/meeting/1/start", { id: 1, language: "no", space_id: 1, space: 1, state: "ongoing" }.to_json, api_key)
  stub_post_body("https://api.swiftner.com/meeting/2/pause", { id: 2, language: "no", space_id: 1, space: 1, state: "paused" }.to_json, api_key)
  stub_post_body("https://api.swiftner.com/meeting/2/end", { id: 2, language: "no", space_id: 1, space: 1, state: "ended" }.to_json, api_key)
  stub_post_body("https://api.swiftner.com/meeting/3/resume", { id: 3, language: "no", space_id: 1, space: 1, state: "ongoing" }.to_json, api_key)
  stub_post("https://api.swiftner.com/meeting/create", api_key)
  stub_put("https://api.swiftner.com/meeting/update/1", api_key)
  stub_delete("https://api.swiftner.com/meeting/delete/1", api_key)

  stub_get("https://api.swiftner.com/recording/get_recordings", [{ id: 1, start: "2024-09-11T06:39:09.301923", path: "https://youtube.com", channel_id: 1, meeting_id: 1, title: "New recording" }].to_json, api_key)
  stub_get("https://api.swiftner.com/recording/get/1", { id: 1, start: "2024-09-11T06:39:09.301923", path: "https://youtube.com", channel_id: 1, meeting_id: 1, title: "New recording" }.to_json, api_key)
  stub_post("https://api.swiftner.com/recording/create", api_key)
  stub_put("https://api.swiftner.com/recording/update/1", api_key)
  stub_delete("https://api.swiftner.com/recording/delete/1", api_key)
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
