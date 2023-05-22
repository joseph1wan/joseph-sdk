# frozen_string_literal: true

module Lotr
  module Sdk
    module Exception
      class InvalidIdError < StandardError
        def initialize(id)
          super("#{id} is an invalid ID. Provide a valid id")
        end
      end
    end
  end
end
