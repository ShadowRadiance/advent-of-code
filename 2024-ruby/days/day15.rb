# frozen_string_literal: true

require_relative "../lib/aoc/grid"
require_relative "../lib/aoc/direction"

module Days
  class Day15
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    Input = Data.define(:grid, :instructions)

    class Entity
      attr_reader :location

      def initialize(location, grid)
        @location = location
        @grid = grid
      end

      def move(direction)
        @grid.set_value_at(@location, Space.new(@location, @grid))
        @location += direction
        @grid.set_value_at(@location, self)
      end
    end

    class Robot < Entity
      def to_s = "@"

      def move(direction)
        element_in_direction = @grid.value_at(@location + direction)
        element_in_direction.move(direction)
        super
      rescue RuntimeError => e
        puts "Robot #{e.message}" unless defined?(RSpec)
      end
    end

    class Boxes < Entity
      def to_s = "O"

      def move(direction)
        element_in_direction = @grid.value_at(@location + direction)
        element_in_direction.move(direction)
        super
      rescue RuntimeError => e
        raise "Box #{e.message}"
      end

      def gps_coordinates
        (100 * @location.y) + @location.x
      end
    end

    class Wall < Entity
      def to_s = "#"

      def move(_direction)
        raise "stopped by Wall"
      end
    end

    class Space < Entity
      def to_s = "."

      def move(_direction)
        # do nothing
      end
    end

    class Solution
      DIRECTIONS = {
        ">" => AOC::Direction.east,
        "<" => AOC::Direction.west,
        "^" => AOC::Direction.north,
        "v" => AOC::Direction.south,
      }.freeze

      def initialize(grid, instructions)
        @grid = grid
        @instructions = instructions
        @robot = nil
        @boxes = []

        @grid.each do |location, char|
          @grid.set_value_at(
            location,
            case char
            when "." then Space.new(location, @grid)
            when "@" then Robot.new(location, @grid).tap { @robot = it }
            when "O" then Boxes.new(location, @grid).tap { @boxes << it }
            when "#" then Wall.new(location, @grid)
            end,
          )
        end
      end

      def run_simulation(steps: nil)
        @instructions.each.with_index do |instruction, idx|
          direction = DIRECTIONS[instruction]
          @robot.move(direction)
          break if steps && idx + 1 >= steps
        end
      end

      def sum_of_all_boxes_gps_coordinates
        @boxes.map(&:gps_coordinates).sum
      end
    end

    def parse_input
      map_str, instructions_str = puzzle_input.split("\n\n")
      grid = AOC::Grid.new(map_str.lines(chomp: true).map(&:chars))
      instructions = instructions_str.lines(chomp: true).join.chars

      Solution.new(grid, instructions)
    end

    def part_a
      solution = parse_input
      solution.run_simulation
      solution.sum_of_all_boxes_gps_coordinates.to_s
    end

    def part_b
      "PENDING_B"
    end

    private

    attr_reader :puzzle_input
  end
end
