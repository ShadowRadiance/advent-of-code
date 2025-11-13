# frozen_string_literal: true

require_relative "../../days/day20"

RSpec.describe "Days::Day20" do
  let(:day_runner) { Days::Day20.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      ###############
      #...#...#.....#
      #.#.#.#.#.###.#
      #S#...#.#.#...#
      #######.#.#.###
      #######.#.#...#
      #######.#.###.#
      ###..E#...#...#
      ###.#######.###
      #...###...#...#
      #.#####.#.###.#
      #.#...#.#.#...#
      #.#.#.#.#.#.###
      #...#...#...###
      ###############
    INPUT
  end

  describe "#part_a" do
    {
      64 => 1,
      40 => 1 + 1,
      38 => 1 + 1 + 1,
      36 => 1 + 1 + 1 + 1,
      20 => 1 + 1 + 1 + 1 + 1,
      12 => 1 + 1 + 1 + 1 + 1 + 3,
      10 => 1 + 1 + 1 + 1 + 1 + 3 + 2,
      8 => 1 + 1 + 1 + 1 + 1 + 3 + 2 + 4,
      6 => 1 + 1 + 1 + 1 + 1 + 3 + 2 + 4 + 2,
      4 => 1 + 1 + 1 + 1 + 1 + 3 + 2 + 4 + 2 + 14,
      2 => 1 + 1 + 1 + 1 + 1 + 3 + 2 + 4 + 2 + 14 + 14,
    }.map do |min_savings, count|
      it "returns #{count} cheats that save at least #{min_savings}ps" do
        expect(day_runner.part_a(save_minimum: min_savings)).to eq(count)
      end
    end
  end

  describe "#part_b" do
    {
      76 => 3,
      74 => 3 + 4,
      72 => 3 + 4 + 22,
      70 => 3 + 4 + 22 + 12,
      68 => 3 + 4 + 22 + 12 + 14,
      66 => 3 + 4 + 22 + 12 + 14 + 12,
      64 => 3 + 4 + 22 + 12 + 14 + 12 + 19,
      62 => 3 + 4 + 22 + 12 + 14 + 12 + 19 + 20,
      60 => 3 + 4 + 22 + 12 + 14 + 12 + 19 + 20 + 23,
      58 => 3 + 4 + 22 + 12 + 14 + 12 + 19 + 20 + 23 + 25,
      56 => 3 + 4 + 22 + 12 + 14 + 12 + 19 + 20 + 23 + 25 + 39,
      54 => 3 + 4 + 22 + 12 + 14 + 12 + 19 + 20 + 23 + 25 + 39 + 29,
      52 => 3 + 4 + 22 + 12 + 14 + 12 + 19 + 20 + 23 + 25 + 39 + 29 + 31,
      50 => 3 + 4 + 22 + 12 + 14 + 12 + 19 + 20 + 23 + 25 + 39 + 29 + 31 + 32,
    }.map do |min_savings, count|
      it "returns #{count} cheats that save at least #{min_savings}ps" do
        expect(day_runner.part_b(save_minimum: min_savings)).to eq(count)
      end
    end
  end
end
