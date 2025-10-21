# frozen_string_literal: true

require_relative "../../days/day10"

RSpec.describe "Days::Day10" do
  let(:day_runner) { Days::Day10.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      89010123
      78121874
      87430965
      96549874
      45678903
      32019012
      01329801
      10456732
    INPUT
  end

  describe "#part_a" do
    it "returns the correct value for part A" do
      expect(day_runner.part_a).to eq "36"
    end
  end

  describe "#part_b" do
    it "returns the correct value for part B" do
      expect(day_runner.part_b).to eq "PENDING_B"
    end
  end
end
