# frozen_string_literal: true

require_relative "swiftner/API/service"
require_relative "swiftner/API/space"
require_relative "swiftner/API/transcription"
require_relative "swiftner/API/upload"
require_relative "swiftner/API/video_content"
require_relative "swiftner/API/linked_content"
require_relative "swiftner/configuration"
require_relative "swiftner/client"
require_relative "swiftner/version"

### Swiftner
module Swiftner
  class Error < StandardError; end
  class Forbidden < Error; end
  class Unauthorized < Error; end
  class NotFound < Error; end
  class InternalError < Error; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
