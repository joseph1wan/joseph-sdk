# frozen_string_literal: true

module Lotr
  module Sdk
    module Exception
      class MissingAccessTokenError < StandardError
        def initialize
          super("Provide client with an access token or set your token to the THE_ONE_ACCESS_TOKEN env variable")
        end
      end
    end
  end
end
