# frozen_string_literal: true

module Lotr
  module Sdk
    # Client instantiates an HTTP client and makes all API calls
    class Client
      ID_REGEX = /^[0-9a-f]{24}$/i.freeze
      MOVIES_WITH_QUOTES = %w[5cd95395de30eff6ebccde5c 5cd95395de30eff6ebccde5b 5cd95395de30eff6ebccde5d"].freeze # IDs for the original trilogy
      PAGINATION_DEFAULT = {
        limit: 100,
        page: 1,
        offset: 0
      }.freeze

      # Initialize client with an access token
      #   1. Sign up at https://the-one-api.dev/sign-up
      #   2. Provide the access token.
      #        You can pass in you token as a parameter
      #          or
      #        Set the token to the THE_ONE_ACCESS_TOKEN env variable
      def initialize(access_token: nil)
        @api_url = "https://the-one-api.dev/v2"
        if access_token.nil?
          access_token = ENV["THE_ONE_ACCESS_TOKEN"]
        end
        raise Exception::MissingAccessTokenError if access_token.nil?

        @client = HTTP.headers(accept: "application/json").auth("Bearer #{access_token}")
      end

      # Fetch all movies
      # @param q [Object] Hash of query parameters. For example: { name: "Series" }
      # @return [Array<Movie>] A list of all movies
      def movies(q: {}, fetch_all: false)
        params = PAGINATION_DEFAULT.merge(q)
        endpoint = "/movie?#{transform_query_parameters(params)}"
        uri = URI("#{@api_url}/#{endpoint}")
        response = JSON.parse(@client.get(uri).body)
        movies_list = response["docs"].map do |movie_data|
          Movie.new(movie_data)
        end
        if fetch_all && (params[:page] * params[:limit]) < response["total"]
          params[:page] += 1
          movies_list += movies(q: params, fetch_all: true)
        end
        movies_list
      end

      # Fetch a specified movie
      # @param id [String] A 24-char string identifying the movie
      # @return [Movie] The movie corresponding to the ID
      def movie(id)
        id = validate_id(id)
        endpoint = "movie/#{id}"
        uri = URI("#{@api_url}/#{endpoint}")
        response = JSON.parse(@client.get(uri).body)
        raise Exception::ResourceNotFoundError.new(:movie, id) if response["total"].zero?

        movie_data = response["docs"].first
        Movie.new(movie_data)
      end

      # Fetch all quotes
      # @param q [Object] Hash of query and pagination parameters. For example: { dialog: "Oooh", page: 2 }
      # @return [Array<Movie>] A list of all movies
      def quotes(q: {}, fetch_all: false)
        params = PAGINATION_DEFAULT.merge(q)
        endpoint = "/quote?#{transform_query_parameters(params)}"
        uri = URI("#{@api_url}/#{endpoint}")
        response = JSON.parse(@client.get(uri).body)
        quotes_list = response["docs"].map do |quote_data|
          Quote.new(quote_data)
        end
        if fetch_all && (params[:page] * params[:limit]) < response["total"]
          params[:page] += 1
          quotes_list += quotes(q: params, fetch_all: true)
        end
        quotes_list
      end

      # Fetch all quotes belonging to a movie.
      # Only Lord of the Rings movie are supported. These movies are:
      #   The Fellowship of the Ring
      #   The Two Towers
      #   The Return of the King
      # @param q [Object] Hash of query and pagination parameters. For example: { dialog: "Oooh", page: 2 }
      # @return [Array<Quote>] All quotes belonging to the movie
      def movie_quotes(id, q: {}, fetch_all: false)
        movie_id = validate_id(id)
        raise Exception::MovieNotSupportedError.new(MOVIES_WITH_QUOTES) unless ENV["DISABLE_MOVIE_CHECK"] || MOVIES_WITH_QUOTES.include?(movie_id)

        params = PAGINATION_DEFAULT.merge(q)
        endpoint = "/movie/#{movie_id}/quote?#{transform_query_parameters(params)}"
        uri = URI("#{@api_url}/#{endpoint}")
        response = JSON.parse(@client.get(uri).body)
        quotes_list = response["docs"].map do |quote_data|
          Quote.new(quote_data)
        end
        if fetch_all && (params[:page] * params[:limit]) < response["total"]
          params[:page] += 1
          quotes_list += quotes(q: params, fetch_all: true)
        end
        quotes_list
      end

      # Fetch all quotes belonging to a movie.
      # Uses movie_quotes with same limitations
      # @return [Array<Quote>] All quotes belonging to the movie
      def movie_quotes_from_movie(movie, q: {})
        movie_quotes(movie.id, q: q)
      end

      # Fetch a specified quote
      # @param id [String] A 24-char string identifying the quote
      # @return [Movie] The quote corresponding to the ID
      def quote(id)
        quote_id = validate_id(id)
        endpoint = "/quote/#{quote_id}"
        uri = URI("#{@api_url}/#{endpoint}")
        response = JSON.parse(@client.get(uri).body)
        raise Exception::ResourceNotFoundError.new(:quote, id) if response["total"].zero?

        quote_data = response["docs"].first
        Quote.new(quote_data)
      end

      private

        # Makes sure ID is a 24-char string
        # return [String]
        def validate_id(id)
          raise Exception::InvalidIdError.new(id) unless ID_REGEX.match?(id.to_s.downcase)

          id
        end

        # Transforms query params from hash to string
        # return [String]
        def transform_query_parameters(params)
          pagination_keys = %i[limit page offset]
          params.map do |k, v|
            if pagination_keys.include?(k)
              "#{k}=#{v}"
            else
              "#{k}=/.*#{v}.*/"
            end
          end.join("&")
        end

        def handle_pagination

        end
    end
  end
end
