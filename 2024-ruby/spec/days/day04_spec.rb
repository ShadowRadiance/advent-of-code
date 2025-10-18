# frozen_string_literal: true

require_relative "../../days/day04"

RSpec.describe "Days::Day04" do
  let(:day_runner) { Days::Day04.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
    INPUT
  end

  describe ".parse_input" do
    it "returns a grid of letters" do
      expect(day_runner.parse_input).to eq(
        [
          %w[M M M S X X M A S M],
          %w[M S A M X M S M S A],
          %w[A M X S X M A A M M],
          %w[M S A M A S M S M X],
          %w[X M A S A M X A M M],
          %w[X X A M M X X A M A],
          %w[S M S M S A S X S S],
          %w[S A X A M A S A A A],
          %w[M A M M M X M M M M],
          %w[M X M X A X M A S X],
        ],
      )
    end
  end

  describe ".xmas_in_direction?" do
    it "returns true when XMAS can be found in direction" do
      ex_loc = Location.new(x: 0, y: 4)
      direction = Direction.compass_directions[:east]
      expect(
        day_runner.xmas_in_direction?(
          ex_loc,
          direction,
        ),
      ).to be(true)
    end
  end

  describe "#part_a" do
    context "with the sample data" do
      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "18"
      end
    end
  end

  describe "#part_b" do
    context "with the sample data" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "9"
      end
    end
  end
end
