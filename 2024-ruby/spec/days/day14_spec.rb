# frozen_string_literal: true

require_relative "../../days/day14"

RSpec.describe "Days::Day14" do
  let(:day_runner) { Days::Day14.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      p=0,4 v=3,-3
      p=6,3 v=-1,-3
      p=10,3 v=-1,2
      p=2,0 v=2,-1
      p=0,0 v=1,3
      p=3,0 v=-2,-2
      p=7,6 v=-1,-3
      p=3,0 v=-1,-2
      p=9,3 v=2,3
      p=7,3 v=-1,2
      p=2,4 v=2,-3
      p=9,5 v=-3,-3
    INPUT
  end

  describe "parsing" do
    it "parses the input into robots" do
      expect(day_runner.parse_input).to eq(
        [
          Days::Day14::Robot.new(AOC::Location.new(0, 4), AOC::Direction.new(3, -3)),
          Days::Day14::Robot.new(AOC::Location.new(6, 3), AOC::Direction.new(-1, -3)),
          Days::Day14::Robot.new(AOC::Location.new(10, 3), AOC::Direction.new(-1, 2)),
          Days::Day14::Robot.new(AOC::Location.new(2, 0), AOC::Direction.new(2, -1)),
          Days::Day14::Robot.new(AOC::Location.new(0, 0), AOC::Direction.new(1, 3)),
          Days::Day14::Robot.new(AOC::Location.new(3, 0), AOC::Direction.new(-2, -2)),
          Days::Day14::Robot.new(AOC::Location.new(7, 6), AOC::Direction.new(-1, -3)),
          Days::Day14::Robot.new(AOC::Location.new(3, 0), AOC::Direction.new(-1, -2)),
          Days::Day14::Robot.new(AOC::Location.new(9, 3), AOC::Direction.new(2, 3)),
          Days::Day14::Robot.new(AOC::Location.new(7, 3), AOC::Direction.new(-1, 2)),
          Days::Day14::Robot.new(AOC::Location.new(2, 4), AOC::Direction.new(2, -3)),
          Days::Day14::Robot.new(AOC::Location.new(9, 5), AOC::Direction.new(-3, -3)),
        ],
      )
    end
  end

  describe "#part_a" do
    it "returns the correct value for part A" do
      expect(day_runner.part_a(testing: true)).to eq "12"
    end
  end

  describe "#part_b" do
    it "returns the correct value for part B" do
      expect(day_runner.part_b).to eq "PENDING_B"
    end
  end
end
