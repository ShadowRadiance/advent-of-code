# frozen_string_literal: true

require_relative "../map"

# rubocop:disable Naming/VariableNumber
module Days
  class Day06
    module Variants
      class Base
        attr_reader :day06

        def initialize(day06)
          @day06 = day06
        end

        def run_simulation_with_obstacle(loc)
          new_map = Map.new(day06.parse_input)
          new_map.set_char_at_loc(loc, "O")
          guard = day06.initialize_guard(new_map)
          day06.record_guard_walk(guard, new_map)
        end
      end
    end
  end
end
# rubocop:enable Naming/VariableNumber
