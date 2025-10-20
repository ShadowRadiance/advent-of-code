# frozen_string_literal: true

require_relative "base"
require_relative "../map"

module Days
  class Day06
    module Variants
      class WalkedLineOnly < Base
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

          # reduces places to check from 10*10=100 down to 41 in test data
          # reduces places to check from 130*130=16900 down to 5444 in live data

          obstacle_locations.filter { run_simulation_with_obstacle(it) == :loop }
                            .length.to_s

          # 1946 in 1m49s
        end
      end
    end
  end
end
