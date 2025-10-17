# frozen_string_literal: true

module Days
  class Day01
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def part_a
      left, right = parse_input

      left.sort!
      right.sort!

      differences = left.map.with_index do |lval, idx|
        (lval - right[idx]).abs
      end

      differences.sum.to_s
    end

    def part_b
      "PENDING-B"
    end
  end
end
