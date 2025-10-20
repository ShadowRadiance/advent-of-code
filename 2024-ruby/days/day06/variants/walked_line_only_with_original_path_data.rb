# frozen_string_literal: true

require_relative "base"
require_relative "../map"
require_relative "../guard"

module Days
  class Day06
    module Variants
      class WalkedLineOnlyWithOriginalPathData < Base
        def solve
          map = Map.new(day06.parse_input)
          guard = day06.initialize_guard(map)
          result, path = day06.guard_walk_path(guard, map)
          raise "THAT SHOULDN'T HAPPEN" if result == :loop

          obstacle_locations = path.map(&:location)
          # remove duplicates
          obstacle_locations = obstacle_locations.uniq
          # remove the initial guard location
          obstacle_locations = obstacle_locations[1..]

          # reduces simulation length by remembering the path up to the obstacle

          obstacle_locations.filter { run_simulation_with_obstacle_and_original_path(it, path) == :loop }
                            .length.to_s

          # 1946 in 39s
        end

        private

        def run_simulation_with_obstacle_and_original_path(loc, orig_path)
          new_map = Map.new(day06.parse_input)
          new_map.set_char_at_loc(loc, "O")

          # find first location of new obstactle along original path, then step back one
          obstacle_index = orig_path.find_index { it.location == loc }
          previous_index = obstacle_index - 1
          path_entry = orig_path[previous_index]

          guard = Guard.new(path_entry.location, path_entry.direction)

          # does it loop?
          day06.record_guard_walk(guard, new_map)
        end
      end
    end
  end
end
