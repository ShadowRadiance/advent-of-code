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
      left, right = parse_input

      similarity_scores = left.map do |lval|
        lval * right.count(lval)
      end

      similarity_scores.sum.to_s
    end

    def parse_input
      left = []
      right = []

      puzzle_input.lines.each do |line|
        a, b = line.split(/\s+/)
        left << a.to_i
        right << b.to_i
      end
      [left, right]
    end

    private

    attr_reader :puzzle_input
  end
end
