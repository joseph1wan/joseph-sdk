# frozen_string_literal: true

module Lotr
  module Sdk
    # Client instantiates an HTTP client and makes all API calls
    class Client
      API_URL = "https://the-one-api.dev/v2"
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
        response = call_api("/movie", params: params)
        movies_list = response_to_model(Movie, response)
        if fetch_all && paginate?
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
        response = call_api("movie/#{id}")
        response_to_model(Movie, response, id: id)
      end

      # Fetch all quotes
      # @param q [Object] Hash of query and pagination parameters. For example: { dialog: "Oooh", page: 2 }
      # @return [Array<Movie>] A list of all movies
      def quotes(q: {}, fetch_all: false)
        params = PAGINATION_DEFAULT.merge(q)
        response = call_api("/quote", params: params)
        quotes_list = response_to_model(Quote, response)
        if fetch_all && paginate?(params, response)
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
        response = call_api("/movie/#{movie_id}/quote", params: params)
        quotes_list = response_to_model(Quote, response)
        if fetch_all && paginate?(params, response)
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
        response = call_api("/quote/#{quote_id}")
        response_to_model(Quote, response, id: id)
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

        # Make API call and handle query parameters
        # @param [String] endpoint Endpoint to make API call against
        # @param [Hash] params Query params
        # @return [Hash] API response
        def call_api(endpoint, params: nil)
          if params
            endpoint = "#{endpoint}?#{transform_query_parameters(params)}"
          end
          uri = URI("#{API_URL}/#{endpoint}")
          JSON.parse(@client.get(uri).body)
        end

        # Transform API response to a class
        # @param [Movie|Quote] model Model to instantiate with response
        # @param [Hash] response Data from the API response
        # @return [Array<Movie|Quote> | Movie | Quote] API response
        def response_to_model(model, response, id: nil)
          if id
            raise Exception::ResourceNotFoundError.new(model.to_s.downcase, id) if response["total"].zero?

            model.new(response["docs"].first)
          else
            response["docs"].map do |data|
              model.new(data)
            end
          end
        end

        # Helper class to determine if pagination needs to continue
        # @param [Hash] params Params hash with page and limit
        # @param [Hash] response Data from the API response
        # @return [Boolean]
        def paginate?(params, response)
          (params[:page] * params[:limit]) < response["total"]
        end
    end
  end
end
