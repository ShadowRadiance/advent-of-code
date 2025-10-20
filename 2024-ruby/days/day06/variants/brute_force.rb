# frozen_string_literal: true

require_relative "base"
require_relative "../map"
require_relative "../../../lib/location"

module Days
  class Day06
    module Variants
      class BruteForce < Base
        def solve
          # allow placing an extra obstacle
          # - how many locations cause a loop
          list = []

          map = Map.new(day06.parse_input)
          map.num_rows.times do |y|
            map.num_cols.times do |x|
              obstacle_loc = Location.new(x: x, y: y)
              next unless map.char_at_loc(obstacle_loc) == "."

              list << obstacle_loc if run_simulation_with_obstacle(obstacle_loc) == :loop
            end
          end
          list.length.to_s

          # YIKES 6m44s! but got the job done correctly (1946)
        end
      end
    end
  end
end
