# frozen_string_literal: true

module Lotr
  module Sdk
    # Quote represents the data of a quote.
    class Quote
      attr_reader :data

      def initialize(data, movie = nil)
        @data = data
        @movie = movie
      end

      # Represents the quote ID
      # @return [String]
      def id
        @data["_id"]
      end

      # Represents the quote text
      # @return [String]
      def dialog
        @data["dialog"]
      end

      # Fetch the ID of the movie the quote comes from
      # @return [String]
      def movie
        @data["movie"]
      end

      # Represents the character that spoke the quote
      # Characters are not supported in this version of the SDK
      # @return [String]
      def character
        @data["character"]
      end
    end
  end
end
