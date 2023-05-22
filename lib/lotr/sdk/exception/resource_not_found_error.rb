# frozen_string_literal: true

module Lotr
  module Sdk
    module Exception
      class ResourceNotFoundError < StandardError
        def initialize(resource_type, id)
          super("Could not find #{resource_type} quote with id: #{id}. Check your ID and try again or provide a valid ID")
        end
      end
    end
  end
end
