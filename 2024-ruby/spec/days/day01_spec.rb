# frozen_string_literal: true

require_relative "../../days/day01"

RSpec.describe "Days::Day01" do
  let(:day_runner) { Days::Day01.new(puzzle_input) }

  describe "#part_a" do
    context "with the sample data" do
      let(:puzzle_input) do
        <<~INPUT
          3   4
          4   3
          2   5
          1   3
          3   9
          3   3
        INPUT
      end

      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "11"
      end
    end
  end

  describe "#part_b" do
    context "with the sample data" do
      let(:puzzle_input) { "" }

      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "PENDING-B"
      end
    end
  end
end
