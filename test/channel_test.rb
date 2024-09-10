# frozen_string_literal: true

require "test_helper"

class ChannelTest < Minitest::Test
  def setup
    @channel_service = Swiftner::API::Channel
    create_and_stub_client
  end

  def stub_api_requests(api_key = "swiftner-api-key")
    stub_get("https://api.swiftner.com/channel/get-channels", [{ id: 1, name: "test", type: "audio", space_id: 1 }].to_json, api_key)
    stub_get("https://api.swiftner.com/channel/is_channel_live?channel_id=1", { "status" => "live" }.to_json, api_key)
    stub_get("https://api.swiftner.com/channel/get/1", { id: 1, name: "test", type: "audio", space_id: 1 }.to_json, api_key)
    stub_post("https://api.swiftner.com/channel/create", api_key)
    stub_put("https://api.swiftner.com/channel/update/1", api_key)
    stub_delete("https://api.swiftner.com/channel/delete/1", api_key)
  end

  def test_find_channels
    channels = @channel_service.find_channels
    assert channels.is_a?(Array)
    assert channels.first.is_a?(Swiftner::API::Channel)
  end

  def test_find_channel
    channel = @channel_service.find(1)
    assert channel.is_a?(Swiftner::API::Channel)
    assert_equal 1, channel.id
  end

  def test_channel_live
    channel = @channel_service.find(1)
    assert channel.live?
  end

  def test_create_channel
    channel = @channel_service.create({ name: "New channel", type: "audio", space_id: 1 })
    assert channel.is_a?(Swiftner::API::Channel)
    refute_nil channel.id
    assert_equal "New channel", channel.details["name"]
  end

  def test_update_channel
    channel = @channel_service.find(1)
    channel.update(name: "New name")
    assert_equal "New name", channel.details["name"]
    assert_equal 1, channel.id
  end

  def test_delete_channel
    channel = @channel_service.find(1)
    response = channel.delete
    assert_equal "success", response["status"]
  end
end
