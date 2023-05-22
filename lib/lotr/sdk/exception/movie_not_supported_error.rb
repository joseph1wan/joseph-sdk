# frozen_string_literal: true

module Lotr
  module Sdk
    module Exception
      class MovieNotSupportedError < StandardError
        def initialize(supported_movies)
          msg = "This movie ID is not supported. Supported movies are: #{supported_movies.join(" ")}"
          super(msg)
        end
      end
    end
  end
end
