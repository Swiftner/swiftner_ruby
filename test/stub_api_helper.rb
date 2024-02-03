# frozen_string_literal: true

module StubApiHelper
  def stub_api(url, return_body, api_key)
    stub_request(:get, url)
      .with(headers: { "Api_Key_Header" => api_key })
      .to_return(
        status: 200,
        body: return_body,
        headers: { "Content-Type" => "application/json" }
      )
  end
end
