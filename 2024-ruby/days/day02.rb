# frozen_string_literal: true

module Days
  class Day02
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def part_a
      reports = parse_input
      reports.count { |r| safe?(r) }.to_s
    end

    def part_b
      "PENDING-B"
    end

    def safe?(report)
      # SAFE is defined as both of the following criteria:
      # - levels are always increasing or always decreasing
      # - each subsequent level differs by at least 1 and at most 3
      return false if report.length < 2

      initial_increasing = report[0] < report[1]
      (report.length - 1).times do |idx|
        return false if violates_direction?(report[idx], report[idx + 1], initial_increasing)
        return false if violates_difference?(report[idx], report[idx + 1])
      end

      true
    end

    def violates_direction?(a, b, initial) # rubocop:disable Naming/MethodParameterName
      next_increasing = a < b
      next_increasing != initial
    end

    def violates_difference?(a, b) # rubocop:disable Naming/MethodParameterName
      next_difference = (a - b).abs
      next_difference < 1 || next_difference > 3
    end

    def parse_input
      puzzle_input.lines(chomp: true)
                  .map { |line| line.split.map(&:to_i) }
    end

    private

    attr_reader :puzzle_input
  end
end
