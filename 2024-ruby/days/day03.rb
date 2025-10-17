# frozen_string_literal: true

module Days
  class Day03
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    RX_GOOD_MUL = /mul\(\d+,\d+\)/
    MUL_VALUES = /mul\((\d+),(\d+)\)/

    def part_a
      puzzle_input.scan(RX_GOOD_MUL)
                  .map { |mul| perform_mul(mul) }
                  .sum
                  .to_s
    end

    def part_b
      "PENDING-B"
    end

    def parse_input
      puzzle_input
    end

    def perform_mul(mul)
      mul.scan(MUL_VALUES)
         .first
         .map(&:to_i)
         .reduce(:*)
    end

    private

    attr_reader :puzzle_input
  end
end
