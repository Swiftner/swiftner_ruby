# frozen_string_literal: true

require "test_helper"

class SpaceTest < Minitest::Test
  def setup
    @space_service = Swiftner::API::Space
    create_and_stub_client
  end

  # rubocop:disable Layout/LineLength
  def stub_api_requests(api_key = "swiftner-api-key")
    stub_get("https://api.swiftner.com/space/get-spaces", [{ id: 1, name: "test", description: "test" }].to_json, api_key)
    stub_get("https://api.swiftner.com/space/get/1", { id: 1, name: "test", description: "test" }.to_json, api_key)
    stub_post("https://api.swiftner.com/space/create", api_key)
    stub_put("https://api.swiftner.com/space/update/1", api_key)
    stub_delete("https://api.swiftner.com/space/delete/1", api_key)
  end
  # rubocop:enable Layout/LineLength

  def test_find_spaces
    spaces = @space_service.find_spaces
    assert spaces.is_a?(Array)
    assert spaces.first.is_a?(Swiftner::API::Space)
  end

  def test_find_space
    space = @space_service.find(1)
    assert space.is_a?(Swiftner::API::Space)
    assert_equal 1, space.id
  end

  def test_create_space
    space = @space_service.create({ name: "New space", description: "For everything new" })
    assert space.is_a?(Swiftner::API::Space)
    refute_nil space.id
    assert_equal "New space", space.details["name"]
  end

  def test_update_space
    space = @space_service.find(1)
    space.update(name: "New name")
    assert_equal "New name", space.details["name"]
    assert_equal 1, space.id
  end

  def test_delete_space
    space = @space_service.find(1)
    response = space.delete
    assert_equal "success", response["status"]
  end
end
