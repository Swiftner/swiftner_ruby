# frozen_string_literal: true

module Swiftner
  ## `Swiftner::Configuration`
  class Configuration
    SUPPORTED_LANGUAGES = %w[en no].freeze
    attr_accessor :client

    def initialize
      @client = nil
    end
  end
end
