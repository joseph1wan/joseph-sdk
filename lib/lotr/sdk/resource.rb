# frozen_string_literal: true

module Lotr
  module Sdk
    # Resource is the base class to infer a model
    class Resource
      attr_reader :data

      def initialize(data)
        @data = data
      end

      # List available data access methods
      # @return [Array<String>]
      def data_access_methods
        @data.keys.map { |k| snakecase(k) }
      end

      # Get ID from data
      # @return [String]
      def id
        @data["_id"]
      end

      # Override method_missing to access data from the API response
      def method_missing(method)
        if data_access_methods.include?(method.to_s)
          @data[camelcase(method.to_s)]
        else
          super
        end
      end

      # Define respond_to_missing? whenever overriding method_missing
      def respond_to_missing?(method, *)
        data_access_methods.include?(method.to_s)
      end

      private

        def camelcase(string)
          components = string.split("_")
          ([components[0]] + components[1..].map(&:capitalize)).join
        end

        def snakecase(string)
          string.scan(/[A-z][a-z]*/).map(&:downcase).join("_")
        end
    end
  end
end
