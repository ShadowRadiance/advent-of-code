# frozen_string_literal: true

require_relative "../../days/day25"

RSpec.describe "Days::Day25" do
  let(:day_runner) { Days::Day25.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      #####
      .####
      .####
      .####
      .#.#.
      .#...
      .....

      #####
      ##.##
      .#.##
      ...##
      ...#.
      ...#.
      .....

      .....
      #....
      #....
      #...#
      #.#.#
      #.###
      #####

      .....
      .....
      #.#..
      ###..
      ###.#
      ###.#
      #####

      .....
      .....
      .....
      #....
      #.#..
      #.#.#
      #####
    INPUT
  end

  describe "#parse_input" do
    it "returns a list of keys and locks in pin-height arrays" do
      locks, keys = day_runner.parse_input

      expect(locks).to eq(
        [
          [0, 5, 3, 4, 3],
          [1, 2, 0, 5, 3],
        ],
      )
      expect(keys).to eq(
        [
          [5, 0, 2, 1, 3],
          [4, 3, 4, 0, 2],
          [3, 0, 2, 0, 1],
        ],
      )
    end
  end

  describe "#part_a" do
    it "returns the correct value for part A" do
      expect(day_runner.part_a).to eq "3"
    end
  end

  describe "#part_b" do
    it "returns the correct value for part B" do
      expect(day_runner.part_b).to eq "PENDING_B"
    end
  end
end
