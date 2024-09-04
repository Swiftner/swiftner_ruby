# frozen_string_literal: true

require "test_helper"

class OrganisationTest < Minitest::Test
  def setup
    @organisation_service = Swiftner::API::Organisation
    create_and_stub_client
  end

  def test_create_organisation
    organisation = @organisation_service.create({ name: "New organisation", description: "For everything new" })
    assert organisation.is_a?(Swiftner::API::Organisation)
    refute_nil organisation.id
    assert_equal "New organisation", organisation.details["name"]
  end
end
