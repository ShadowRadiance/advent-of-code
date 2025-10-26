# frozen_string_literal: true

require_relative "base"
require_relative "../map"
require_relative "../path_entry"
require_relative "../../../lib/aoc/direction"

module Days
  class Day06
    module Variants
      class StateTransitionsVersion < Base
        def solve
          map = Map.new(day06.parse_input)
          state_transitions = build_state_transitions(map)
          guard = day06.initialize_guard(map)
          path_entry_for_guard = PathEntry.new(guard.location, guard.direction)
          original_guard_path = get_full_path(state_transitions, path_entry_for_guard)

          solve_with_obstacles(original_guard_path, state_transitions).sum.to_s

          # 1946 in 26s -- not phenomenal but better
        end

        private

        def solve_with_obstacles(original_guard_path, state_transitions)
          obstacle_locations = original_guard_path
                               .filter { it != :exit }
                               .map(&:location)
                               .uniq
                               .[](1..)

          obstacle_locations.map do |obstacle_location|
            new_state_transitions = update_state_transitions_for_obstacle(
              state_transitions.dup,
              obstacle_location,
            )

            # start the guard at the position right before the obstacle_location
            obstacle_index = original_guard_path.find_index { it.location == obstacle_location }
            previous_index = obstacle_index - 1
            new_path_entry_for_guard = original_guard_path[previous_index]

            path_loops?(new_state_transitions, new_path_entry_for_guard) ? 1 : 0
          end
        end

        def build_state_transitions(map)
          result = {}
          map.num_rows.times do |y|
            map.num_cols.times do |x|
              [north, east, south, west].each do |dir|
                path_entry = PathEntry.new(AOC::Location.new(x: x, y: y), dir)
                result[path_entry] = build_state_transition(path_entry, map)
              end
            end
          end
          result
        end

        def build_state_transition(path_entry, map) # rubocop:disable Metrics/MethodLength
          loc = path_entry.location
          dir = path_entry.direction
          potential_new_loc = loc + dir
          if %w[# O].include?(map.char_at_loc(potential_new_loc))
            dir = dir.rotate90right
          else
            loc = potential_new_loc
          end

          new_path_entry = PathEntry.new(loc, dir)
          if new_path_entry.location.in_bounds?(map.bounds)
            new_path_entry
          else
            :exit
          end
        end

        def update_state_transitions_for_obstacle(state_transitions, obstacle_location)
          [
            PathEntry.new(location: obstacle_location + north, direction: south),
            PathEntry.new(location: obstacle_location + south, direction: north),
            PathEntry.new(location: obstacle_location + east, direction: west),
            PathEntry.new(location: obstacle_location + west, direction: east),
          ].each do |pe|
            update_state_transition_at_pe_for_obstacle(pe, state_transitions)
          end

          state_transitions
        end

        def update_state_transition_at_pe_for_obstacle(path_entry, state_transitions)
          return unless state_transitions[path_entry]

          state_transitions[path_entry] =
            PathEntry.new(path_entry.location, path_entry.direction.rotate90right)
        end

        def get_full_path(state_transitions, path_entry_for_guard)
          result = []
          current_entry = path_entry_for_guard

          loop do
            break if current_entry.nil?

            current_entry = :loop if result.include?(current_entry)
            result << current_entry
            current_entry = state_transitions[current_entry]
          end

          result
        end

        def path_loops?(state_transitions, path_entry_for_guard)
          seen = Set.new
          current_entry = path_entry_for_guard

          until seen.include?(current_entry)
            return false if current_entry == :exit

            seen << current_entry

            current_entry = state_transitions[current_entry]
          end

          true
        end

        def north = AOC::Direction.north
        def south = AOC::Direction.south
        def west = AOC::Direction.west
        def east = AOC::Direction.east
      end
    end
  end
end
