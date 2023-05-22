# frozen_string_literal: true

module Lotr
  module Sdk
    RSpec.describe Client do
      describe "#initialize" do
        context "when access token and environment variable is not set" do
          it "raises an error" do
            token = ENV.delete("THE_ONE_ACCESS_TOKEN")
            expect { Client.new }.to raise_error(Exception::MissingAccessTokenError)
            ENV["THE_ONE_ACCESS_TOKEN"] = token
          end
        end
      end

      describe "#movies" do
        it "returns a list of all movies" do
          result = Client.new.movies
          expect(result.any?).to be_truthy
          expect(result.map(&:class).uniq.first).to eq(Lotr::Sdk::Movie)
        end

        context "search for name" do
          it "looks for movies with a matching name" do
            search_term = "Series"
            movies = Client.new.movies(q: { name: search_term})
            expect(movies.any?).to be_truthy
            movies.each do |movie|
              expect(movie.name).to include(search_term)
            end
          end
        end
      end

      describe "#movie" do
        context "valid id" do
          let(:lotr_series_id) { "5cd95395de30eff6ebccde56" }
          it "returns a specific movie by ID" do
            result = Client.new.movie(lotr_series_id)
            expect(result.class).to eq(Lotr::Sdk::Movie)
            expect(result.name).to eq("The Lord of the Rings Series")
          end
        end

        context "invalid id" do
          context "id invalid format" do
            let(:id) { "1" }
            it "raised an error" do
              expect { Client.new.movie(id) }.to raise_error(Exception::InvalidIdError)
            end
          end

          context "id not found" do
            let(:id) { "0cd95395de30eff6ebccde56" }
            it "raised an error" do
              expect { Client.new.movie(id) }.to raise_error(Exception::ResourceNotFoundError, /movie/)
            end
          end
        end
      end

      describe "#quotes" do
        it "returns a list of quotes for the given movie" do
          result = Client.new.quotes
          expect(result.any?).to be_truthy
          expect(result.map(&:class).uniq.first).to eq(Lotr::Sdk::Quote)
        end
      end

      describe "#movie_quotes" do
        context "movie is a LotR trilogy entry" do
          let(:two_towers_id) { "5cd95395de30eff6ebccde5b" }
          it "returns a list of quotes for the given movie" do
            result = Client.new.movie_quotes(two_towers_id)
            expect(result.any?).to be_truthy
            expect(result.map(&:class).uniq.first).to eq(Lotr::Sdk::Quote)
          end
        end

        context "movie is not a LotR trilogy entry" do
          let(:lotr_series_id) { "5cd95395de30eff6ebccde56" }
          it "returns currently not supported error or empty if check disabled" do
            if ENV["DISABLE_MOVIE_CHECK"]
              expect(Client.new.movie_quotes(lotr_series_id)).to be_empty
            else
              expect { Client.new.movie_quotes(lotr_series_id) }.to raise_error(Exception::MovieNotSupportedError)
            end
          end
        end
      end

      describe "#movie_quotes_from_movie" do
        let(:two_towers_id) { "5cd95395de30eff6ebccde5b" }
        it "returns a list of quotes for the given movie" do
          movie = Movie.new("_id" => two_towers_id)
          result = Client.new.movie_quotes_from_movie(movie)
          expect(result.any?).to be_truthy
          expect(result.map(&:class).uniq.first).to eq(Lotr::Sdk::Quote)
        end
      end

      describe "#quote" do
        let(:oooohhh_quote_id) { "5cd96e05de30eff6ebcce7f7" }
        it "returns a list of quote with the specified ID" do
          result = Client.new.quote(oooohhh_quote_id)
          expect(result.is_a?(Lotr::Sdk::Quote)).to be_truthy
          expect(result.dialog).to eq("Oooohhh!")
        end

        context "invalid id" do
          context "id invalid format" do
            let(:id) { "1" }
            it "raised an error" do
              expect { Client.new.quote(id) }.to raise_error(Exception::InvalidIdError)
            end
          end

          context "id not found" do
            let(:id) { "0cd95395de30eff6ebccde56" }
            it "raised an error" do
              expect { Client.new.quote(id) }.to raise_error(Exception::ResourceNotFoundError, /quote/)
            end
          end
        end
      end
    end
  end
end
