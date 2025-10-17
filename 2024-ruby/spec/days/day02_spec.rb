# frozen_string_literal: true

require_relative "../../days/day02"

RSpec.describe "Days::Day02" do
  let(:day_runner) { Days::Day02.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      7 6 4 2 1
      1 2 7 8 9
      9 7 6 2 1
      1 3 2 4 5
      8 6 4 4 1
      1 3 6 7 9
    INPUT
  end

  describe ".parse_input" do
    it "returns a list of reports with levels as integers" do
      expect(day_runner.parse_input).to eq(
        [
          [7, 6, 4, 2, 1],
          [1, 2, 7, 8, 9],
          [9, 7, 6, 2, 1],
          [1, 3, 2, 4, 5],
          [8, 6, 4, 4, 1],
          [1, 3, 6, 7, 9],
        ],
      )
    end
  end

  describe "#part_a" do
    context "with the sample data" do
      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "2"
      end
    end
  end

  describe "#part_b" do
    context "with the sample data" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "PENDING-B"
      end
    end
  end
end
