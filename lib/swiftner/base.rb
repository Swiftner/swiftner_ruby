# frozen_string_literal: true

module Swiftner
  ## `Swiftner::Base`
  class Base
    @client = nil

    class << self
      attr_accessor :client
    end
  end
end
