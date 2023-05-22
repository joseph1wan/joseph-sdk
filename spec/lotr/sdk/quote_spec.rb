# frozen_string_literal: true

module Lotr
  module Sdk
    RSpec.describe Movie do
      let(:data) do
        {
          "_id" => "5cd96e05de30eff6ebcce7f7",
          "dialog" => "Oooohhh!",
          "movie" => "5cd95395de30eff6ebccde5d",
          "character" => "5cd99d4bde30eff6ebccfc15"
        }
      end

      describe "#id" do
        it "returns the id" do
          expect(Quote.new(data).id).to eq("5cd96e05de30eff6ebcce7f7")
        end
      end

      describe "#movie" do
        it "returns the movie id" do
          expect(Quote.new(data).movie).to eq("5cd95395de30eff6ebccde5d")
        end
      end

      describe "#character" do
        it "returns the character" do
          expect(Quote.new(data).character).to eq("5cd99d4bde30eff6ebccfc15")
        end
      end
    end
  end
end
