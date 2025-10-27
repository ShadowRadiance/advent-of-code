# frozen_string_literal: true

require_relative "../../days/day15"

RSpec.describe "Days::Day15" do
  let(:day_runner) { Days::Day15.new(puzzle_input) }

  describe "#part_a" do
    it "returns the correct value for part A" do
      expect(day_runner.part_a).to eq "PENDING_A"
    end
  end

  describe "#part_b" do
    it "returns the correct value for part B" do
      expect(day_runner.part_b).to eq "PENDING_B"
    end
  end
end
