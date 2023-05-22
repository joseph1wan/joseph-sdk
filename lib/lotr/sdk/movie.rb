# frozen_string_literal: true

module Lotr
  module Sdk
    # Movie represents the data of a movie.
    class Movie
      attr_reader :data, :quotes

      def initialize(data)
        @data = data
        @quotes = []
      end

      # Represents the movie ID
      # @return [String]
      def id
        @data["_id"]
      end

      # Represents the movie title
      # @return [String]
      def name
        @data["name"]
      end

      # Represents the movie length
      # @return [Integer]
      def run_time_minutes(format: false)
        @data["runtimeInMinutes"]
      end

      # Represents the movie budget in milions
      # @return [Integer]
      def budget_millions
        @data["budgetInMillions"]
      end

      # Represents the movie revenue in milions
      # @return [Integer]
      def revenue_millions
        @data["boxOfficeRevenueInMillions"]
      end

      # Represents the number of Academy Award nominations
      # @return [Integer]
      def academy_award_nominations
        @data["academyAwardNominations"]
      end

      # Represents the number of Academy Awards won
      # @return [Integer]
      def academy_award_wins
        @data["academyAwardWins"]
      end

      # Represents the score out of 100 on Rotten Tomatoes
      # @return [Integer]
      def rotten_tomatoes_score
        @data["rottenTomatoesScore"]
      end
    end
  end
end
