# frozen_string_literal: true

require "test_helper"

class SpaceTest < Minitest::Test
  def setup
    @space_service = Swiftner::API::Space
    create_and_stub_client
  end

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
