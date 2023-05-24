# frozen_string_literal: true

require "lotr/sdk"
require "pry"
require "vcr"
require "webmock"

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.default_cassette_options = {
    serialize_with: :json
  }
  config.hook_into :webmock
  config.ignore_localhost = true
  config.filter_sensitive_data("<ACCESS_TOKEN>") { ENV["THE_ONE_ACCESS_TOKEN"] }
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
