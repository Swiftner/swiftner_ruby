# frozen_string_literal: true

module Swiftner
  module API
    # The `Service` class acts as a base class for API operations and data encapsulation.
    class Service
      attr_reader :id, :details, :client

      def self.build(details)
        new(details)
      end

      def self.client
        Swiftner.configuration.client
      end

      def self.validate_required(attributes, *keys)
        missing_keys = find_missing_keys(attributes, keys)

        return unless missing_keys.any?

        # Formatting error message
        formatted_keys = missing_keys.map do |key|
          key.is_a?(Array) ? "(#{key.join(" or ")})" : key
        end.join(", ")

        raise ArgumentError, "Key(s) '#{formatted_keys}' are missing in attributes. #{attributes.inspect}"
      end

      def self.validate_language(attributes, key = :language)
        return unless attributes.key?(key)

        return if Swiftner::Configuration::SUPPORTED_LANGUAGES.include?(attributes[key])

        raise ArgumentError, "Language '#{attributes[key]}' is not supported.
                              Supported languages are #{Swiftner::Configuration::SUPPORTED_LANGUAGES.join(", ")}"
      end

      def self.validate_file(file_path)
        raise ArgumentError, "File does not exist" unless File.exist?(file_path)
        raise ArgumentError, "File is unreadable" unless File.readable?(file_path)

        file_extension = File.extname(file_path).delete_prefix(".")
        video_file_types = Swiftner.configuration.fetch_accepted_file_types[:video]
        audio_file_types = Swiftner.configuration.fetch_accepted_file_types[:audio]
        accepted_file_types = video_file_types + audio_file_types
        return if accepted_file_types.include?(file_extension)

        raise ArgumentError,
              "File type '#{file_extension}' is not supported. Supported file types: #{accepted_file_types.join(", ")}"
      end

      def self.map_collection(response)
        response.map { |item| build(item) }
      end

      def initialize(attributes = {}, client = self.class.client)
        raise Swiftner::Error, "Client must be set" if client.nil?

        @id = attributes["id"]
        @details = attributes
        @client = client
      end

      # Finds keys or key group (if an array) that are missing from the given attributes.
      # Only one of each key group is required to be present in the attributes.
      def self.find_missing_keys(attributes, keys)
        attr_str_keys = attributes.transform_keys(&:to_s)
        keys.reject do |key|
          key = Array(key).map(&:to_s)
          key.map(&:to_s).any? { |k| attr_str_keys.key?(k) }
        end
      end
    end
  end
end
