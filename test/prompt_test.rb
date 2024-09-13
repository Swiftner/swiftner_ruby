# frozen_string_literal: true

require "test_helper"

class PromptTest < Minitest::Test
  def setup
    @prompt_service = Swiftner::API::Prompt
    create_and_stub_client
  end

  def test_find_prompts
    prompts = @prompt_service.find_prompts
    assert prompts.is_a?(Array)
    assert prompts.first.is_a?(Swiftner::API::Prompt)
  end

  def test_find_prompt
    prompt = @prompt_service.find(1)
    assert prompt.is_a?(Swiftner::API::Prompt)
    assert_equal 1, prompt.id
  end

  def test_create_prompt
    prompt = @prompt_service.create({ text: "New prompt", description: "For everything new" })
    assert prompt.is_a?(Swiftner::API::Prompt)
    refute_nil prompt.id
    assert_equal "New prompt", prompt.details["text"]
  end

  def test_update_prompt
    prompt = @prompt_service.find(1)
    prompt.update(text: "New text")
    assert_equal "New text", prompt.details["text"]
    assert_equal 1, prompt.id
  end

  def test_delete_prompt
    prompt = @prompt_service.find(1)
    response = prompt.delete
    assert_equal "success", response["status"]
  end
end
