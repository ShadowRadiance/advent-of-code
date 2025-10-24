# frozen_string_literal: true

require_relative "../../days/day11"

RSpec.describe "Days::Day11" do
  let(:day_runner) { Days::Day11.new(puzzle_input) }

  let(:puzzle_input) { "125 17" }

  describe "#part_a" do
    it "returns the correct value for part A" do
      expect(day_runner.part_a).to eq "55312"
    end
  end

  describe "#part_b" do
    it "returns the correct value for part B" do
      expect(day_runner.part_b).to eq "PENDING_B"
    end
  end
end
