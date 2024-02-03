# frozen_string_literal: true

module StubApiHelper
  def stub_get(url, return_body, api_key)
    stub_request(:get, build_url(url))
      .with(headers: { "Api_Key_Header" => api_key })
      .to_return(
        status: 200,
        body: return_body,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def stub_post(url, api_key)
    stub_request(:post, build_url(url))
      .with(headers: { "Api_Key_Header" => api_key })
      .to_return do |request|
      persisted_body = JSON.parse(request.body)
      persisted_body["id"] = 1
      { status: 200, body: persisted_body.to_json, headers: { "Content-Type" => "application/json" } }
    end
  end

  def stub_delete(url, api_key)
    stub_request(:delete, build_url(url))
      .with(headers: { "Api_Key_Header" => api_key })
      .to_return(
        status: 200,
        body: { status: "success" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  private

  def build_url(url)
    "#{url}?api_key_query=***REMOVED***"
  end
end
