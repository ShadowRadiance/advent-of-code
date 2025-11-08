# frozen_string_literal: true

require_relative "../../days/day18"

RSpec.describe "Days::Day18" do
  let(:day_runner) { Days::Day18.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      5,4
      4,2
      4,5
      3,0
      2,1
      6,3
      2,4
      1,5
      0,6
      3,3
      2,6
      5,1
      1,2
      5,5
      2,5
      6,5
      1,4
      0,4
      6,4
      1,1
      6,1
      1,0
      0,5
      1,6
      2,0
    INPUT
  end

  describe "#part_a" do
    it "returns the correct value for part A" do
      expect(day_runner.part_a(testing: true)).to eq "22"
    end
  end

  fdescribe "#part_b" do
    it "returns the correct value for part B" do
      expect(day_runner.part_b(testing: true)).to eq "6,1"
    end
  end
end
