# frozen_string_literal: true

require_relative "../lib/bounds"
require_relative "../lib/location"
require_relative "../lib/direction"

module Days
  class Day06
    class Guard
      attr_reader :location, :direction

      def initialize(location, direction)
        @location = location
        @direction = direction
        # Direction.from_char(direction_char)
      end

      def turn_right
        @direction = @direction.rotate90right
      end

      def move_forward
        @location += @direction
      end
    end

    class Map
      def initialize(matrix)
        @matrix = matrix
        @num_rows = matrix.length
        @num_cols = matrix&.first&.length || 0
      end

      attr_reader :num_rows, :num_cols

      # returns Location|nil
      def find_char(char)
        num_rows.times do |row_idx|
          num_cols.times do |col_idx|
            return Location.new(x: col_idx, y: row_idx) if @matrix[row_idx][col_idx] == char
          end
        end
        nil
      end

      def char_at_loc(loc)
        return nil unless loc.in_bounds?(bounds)

        @matrix[loc.y][loc.x]
      end

      def set_char_at_loc(loc, char)
        raise unless loc.in_bounds?(bounds)

        @matrix[loc.y][loc.x] = char
      end

      def count_chars(char)
        @matrix.sum { |r| r.count(char) }
      end

      def bounds
        Bounds.new(
          min_x: 0,
          min_y: 0,
          max_x: num_cols - 1,
          max_y: num_rows - 1,
        )
      end
    end

    PathEntry = Data.define(:location, :direction) do
      def inspect
        "<#{location.x},#{location.y},#{direction.to_c}>"
      end
    end

    def parse_input
      puzzle_input.lines(chomp: true).map(&:chars)
    end

    def initialize_guard(map)
      %w[^ v < >].filter_map do |char|
        location = map.find_char(char)
        next unless location

        Guard.new(location, Direction.from_char(char))
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

    class PartB < Day06
      def run_simulation_with_obstacle(loc)
        new_map = Map.new(parse_input)
        new_map.set_char_at_loc(loc, "O")
        guard = initialize_guard(new_map)
        record_guard_walk(guard, new_map)
      end
    end

    class BruteForce < PartB
      def solve
        # allow placing an extra obstacle
        # - how many locations cause a loop
        list = []

        map = Map.new(parse_input)
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

    class WalkedLineOnly < PartB
      def solve
        map = Map.new(parse_input)
        guard = initialize_guard(map)
        result, path = guard_walk_path(guard, map)
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

    class WalkedLineOnlyWithOriginalPathData < PartB
      def solve
        map = Map.new(parse_input)
        guard = initialize_guard(map)
        result, path = guard_walk_path(guard, map)
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
        new_map = Map.new(parse_input)
        new_map.set_char_at_loc(loc, "O")

        # find first location of new obstactle along original path, then step back one
        obstacle_index = orig_path.find_index { it.location == loc }
        previous_index = obstacle_index - 1
        path_entry = orig_path[previous_index]

        guard = Guard.new(path_entry.location, path_entry.direction)

        # does it loop?
        record_guard_walk(guard, new_map)
      end
    end

    class StateTransitionsVersion < Day06
      def solve
        map = Map.new(parse_input)
        state_transitions = build_state_transitions(map)
        guard = initialize_guard(map)
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
              path_entry = PathEntry.new(Location.new(x: x, y: y), dir)
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

      def north = Direction.north
      def south = Direction.south
      def west = Direction.west
      def east = Direction.east
    end

    # ---

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
      # solver = BruteForce.new(puzzle_input)
      # solver.solve # 6m44s!
      # solver = WalkedLineOnly.new(puzzle_input)
      # solver.solve # 1m49s
      # solver = WalkedLineOnlyWithOriginalPathData.new(puzzle_input)
      # solver.solve # 39s
      solver = StateTransitionsVersion.new(puzzle_input)
      solver.solve # 26s

      # Possibilities for improvement
      # - reduce copying
      # - reduce object (re-)creation
      # - store just the obstacles in a set/hash instead of using a grid of chars
    end

    private

    attr_reader :puzzle_input
  end
end
