# frozen_string_literal: true

require_relative "../../days/day21"

RSpec.describe "Days::Day21" do
  let(:day_runner) { Days::Day21.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      placeholder
    INPUT
  end

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
