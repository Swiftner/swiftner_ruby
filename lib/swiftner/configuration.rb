# frozen_string_literal: true

module Swiftner
  ## `Swiftner::Configuration`
  class Configuration
    attr_accessor :client

    def initialize
      @client = nil
    end
  end
end
