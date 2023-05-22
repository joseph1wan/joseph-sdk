# frozen_string_literal: true

RSpec.describe Lotr::Sdk do
  it "has a version number" do
    expect(Lotr::Sdk::VERSION).not_to be nil
  end
end
