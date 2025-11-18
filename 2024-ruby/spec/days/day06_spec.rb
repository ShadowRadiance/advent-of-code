# frozen_string_literal: true

require_relative "../../days/day06"

RSpec.describe "Days::Day06" do
  let(:day_runner) { Days::Day06.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      ....#.....
      .........#
      ..........
      ..#.......
      .......#..
      ..........
      .#..^.....
      ........#.
      #.........
      ......#...
    INPUT
  end

  describe "#parse_input" do
    it "returns a matrix of the values" do
      expect(day_runner.parse_input).to eq(
        [
          %w[. . . . # . . . . .],
          %w[. . . . . . . . . #],
          %w[. . . . . . . . . .],
          %w[. . # . . . . . . .],
          %w[. . . . . . . # . .],
          %w[. . . . . . . . . .],
          %w[. # . . ^ . . . . .],
          %w[. . . . . . . . # .],
          %w[# . . . . . . . . .],
          %w[. . . . . . # . . .],
        ],
      )
    end
  end

  describe "#part_a" do
    context "with the sample data" do
      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "41"
      end
    end
  end

  describe "#part_b" do
    context "with the sample data" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "6"
      end
    end
  end
end
