# frozen_string_literal: true

module Lotr
  module Sdk
    RSpec.describe Resource do
      let(:data) do
        {
          "singleword" => 1,
          "twoWords" => 2,
          "capitalizeThreeWords" => 3
        }
      end

      describe "#data_access_methods" do
        it "returns list of methods based on data" do
          expect(Resource.new(data).data_access_methods).to match_array(%w[singleword two_words capitalize_three_words])
        end
      end

      describe "#method_missing" do
        it "counts data_access_methods as methods" do
          resource = Resource.new(data)
          resource.data_access_methods.each do |method_name|
            expect(resource.respond_to?(method_name)).to be_truthy
          end
        end

        context "camelCase" do
          it "raises NoMethodError" do
            resource = Resource.new(data)
            expect(resource.singleword).to eq(1)
            expect { resource.twoWords }.to raise_error(NoMethodError)
            expect { resource.capitalizeThreeWords }.to raise_error(NoMethodError)
          end
        end

        context "snake_case" do
          it "access the data" do
            resource = Resource.new(data)
            expect(resource.singleword).to eq(1)
            expect(resource.two_words).to eq(2)
            expect(resource.capitalize_three_words).to eq(3)
          end
        end
      end
    end
  end
end
