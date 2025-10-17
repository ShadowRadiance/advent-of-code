# frozen_string_literal: true

require_relative "../../days/day03"

RSpec.describe "Days::Day03" do
  let(:day_runner) { Days::Day03.new(puzzle_input) }

  let(:puzzle_input) { "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))" }

  describe ".parse_input" do
    it "returns a list of reports with levels as integers" do
      expect(day_runner.parse_input).to eq(puzzle_input)
    end
  end

  describe "#part_a" do
    context "with the sample data" do
      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "161"
      end
    end
  end

  describe "#part_b" do
    context "with the sample data" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "48"
      end
    end
  end
end
