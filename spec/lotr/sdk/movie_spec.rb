# frozen_string_literal: true

module Lotr
  module Sdk
    RSpec.describe Movie do
      let(:data) do
        {
          "_id" => "5cd95395de30eff6ebccde56",
          "name" => "The Lord of the Rings Series",
          "runtimeInMinutes" => 558,
          "budgetInMillions" => 281,
          "boxOfficeRevenueInMillions" => 2917,
          "academyAwardNominations" => 30,
          "academyAwardWins" => 17,
          "rottenTomatoesScore" => 94
        }
      end

      before(:all) do
        @client = Lotr::Sdk::Client.new
      end

      context "Display methods" do
        describe "#id" do
          it "returns the id" do
            expect(Movie.new(data).id).to eq("5cd95395de30eff6ebccde56")
          end
        end

        describe "#name" do
          it "returns the name" do
            expect(Movie.new(data).name).to eq("The Lord of the Rings Series")
          end
        end

        describe "#run_time_minutes" do
          it "returns run time in minutes" do
            expect(Movie.new(data).run_time_minutes).to eq(558)
          end
        end

        describe "#budget_millions" do
          it "returns the budget in millions" do
            expect(Movie.new(data).budget_millions).to eq(281)
          end
        end

        describe "#revenue_millions" do
          it "returns the revenue in millions" do
            expect(Movie.new(data).revenue_millions).to eq(2917)
          end
        end

        describe "#academy_award_nominations" do
          it "returns academy award nomination" do
            expect(Movie.new(data).academy_award_nominations).to eq(30)
          end
        end

        describe "#academy_award_wins" do
          it "returns academy award wins" do
            expect(Movie.new(data).academy_award_wins).to eq(17)
          end
        end

        def rotten_tomatoes_score
          it "returns Rotten Tomatoes score" do
            expect(Movie.new(data).rotten_tomatoes_score).to eq(94)
          end
        end
      end
    end
  end
end
