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

    def count_guarded_locations(map)
      map.count_chars("X")
    end

    def run_simulation_with_obstacle(loc)
      new_map = Map.new(parse_input)
      new_map.set_char_at_loc(loc, "O")
      guard = initialize_guard(new_map)
      record_guard_walk(guard, new_map)
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
      # allow placing an extra obstacle
      # - how many locations cause a loop
      list = []

      map = Map.new(parse_input)
      map.num_rows.times do |y|
        map.num_cols.times do |x|
          puts "Checking location x: #{x}, y: #{y}"

          obstacle_loc = Location.new(x: x, y: y)
          next unless map.char_at_loc(obstacle_loc) == "."

          list << obstacle_loc if run_simulation_with_obstacle(obstacle_loc) == :loop
        end
      end
      list.length.to_s

      # YIKES 6m44s!
    end

    private

    attr_reader :puzzle_input
  end
end
