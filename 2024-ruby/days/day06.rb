# frozen_string_literal: true

require_relative "../lib/aoc/bounds"
require_relative "../lib/aoc/direction"

require_relative "day06/guard"
require_relative "day06/map"
require_relative "day06/path_entry"

# part b variations
require_relative "day06/variants/brute_force"
require_relative "day06/variants/walked_line_only"
require_relative "day06/variants/walked_line_only_with_original_path_data"
require_relative "day06/variants/state_transitions_version"

module Days
  class Day06
    def parse_input
      puzzle_input.lines(chomp: true).map(&:chars)
    end

    def initialize_guard(map)
      %w[^ v < >].filter_map do |char|
        location = map.find_char(char)
        next unless location

        Guard.new(location, AOC::Direction.from_char(char))
      end.first
    end

    # returns :out if we walk out and :loop if we loop
    def record_guard_walk(guard, map) # rubocop:disable Metrics/MethodLength
      seen = {}

      while guard.location.in_bounds?(map.bounds)
        return :loop if seen[[guard.location, guard.direction]]

        seen[[guard.location, guard.direction]] = true
        map.set_char_at_loc(guard.location, "X")

        if %w[# O].include?(map.char_at_loc(guard.location + guard.direction))
          guard.turn_right
        else
          guard.move_forward
        end
      end

      :out
    end

    # returns :out if we walk out and :loop if we loop, along with the path
    def guard_walk_path(guard, map) # rubocop:disable Metrics/MethodLength
      seen = {}
      path = []

      while guard.location.in_bounds?(map.bounds)
        path << PathEntry.new(guard.location, guard.direction)
        return [:loop, path] if seen[[guard.location, guard.direction]]

        seen[[guard.location, guard.direction]] = true
        map.set_char_at_loc(guard.location, "X")

        if %w[# O].include?(map.char_at_loc(guard.location + guard.direction))
          guard.turn_right
        else
          guard.move_forward
        end
      end

      [:out, path]
    end

    def count_guarded_locations(map)
      map.count_chars("X")
    end

    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def part_a
      map = Map.new(parse_input)
      guard = initialize_guard(map)
      record_guard_walk(guard, map)

      count_guarded_locations(map).to_s
    end

    def part_b
      # Variants::BruteForce.new(self).solve # 6m44s!
      # Variants::WalkedLineOnly.new(self).solve # 1m49s
      # Variants::WalkedLineOnlyWithOriginalPathData.new(self).solve # 39s
      Variants::StateTransitionsVersion.new(self).solve # 26s

      # Possibilities for improvement
      # - reduce copying
      # - reduce object (re-)creation
      # - store just the obstacles in a set/hash instead of using a grid of chars
    end

    private

    attr_reader :puzzle_input
  end
end
