# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "swiftner"

require "minitest/autorun"
require "webmock/minitest"
require "stub_api_helper"
