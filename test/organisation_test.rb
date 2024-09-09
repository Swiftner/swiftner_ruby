# frozen_string_literal: true

require "test_helper"

class OrganisationTest < Minitest::Test
  def setup
    @organisation_service = Swiftner::API::Organisation
    create_and_stub_client
  end

  # rubocop:disable Layout/LineLength
  def stub_api_requests(api_key = "swiftner-api-key")
    stub_get("https://api.swiftner.com/organisation/get-current-user-orgs", [{ id: 1, name: "test", description: "test" }].to_json, api_key)
    stub_get("https://api.swiftner.com/organisation/get/1", { id: 1, name: "test", description: "test" }.to_json, api_key)
    stub_put_body("https://api.swiftner.com/organisation/add-org-to-token?organisation_id=1", { "access_token" => "eyekljsadflkajdfs" }.to_json, api_key)
    stub_post("https://api.swiftner.com/organisation/create", api_key)
    stub_put("https://api.swiftner.com/organisation/update/1", api_key)
    stub_delete("https://api.swiftner.com/organisation/delete/1", api_key)
  end
  # rubocop:enable Layout/LineLength

  def test_find_organisations
    organisations = @organisation_service.find_organisations
    assert organisations.is_a?(Array)
    assert organisations.first.is_a?(Swiftner::API::Organisation)
  end

  def test_find_organisation
    organisation = @organisation_service.find(1)
    assert organisation.is_a?(Swiftner::API::Organisation)
    assert_equal 1, organisation.id
  end

  def test_add_org_to_token
    response = @organisation_service.add_org_to_token(1)
    assert_instance_of String, response["access_token"]
  end

  def test_create_organisation
    organisation = @organisation_service.create({ name: "New organisation", description: "For everything new" })
    assert organisation.is_a?(Swiftner::API::Organisation)
    refute_nil organisation.id
    assert_equal "New organisation", organisation.details["name"]
  end

  def test_update_organisation
    organisation = @organisation_service.find(1)
    organisation.update(name: "New name")
    assert_equal "New name", organisation.details["name"]
    assert_equal 1, organisation.id
  end

  def test_delete_organisation
    organisation = @organisation_service.find(1)
    response = organisation.delete
    assert_equal "success", response["status"]
  end
end
