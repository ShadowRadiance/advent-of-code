# frozen_string_literal: true

require_relative "../lib/aoc/grid"
require_relative "../lib/aoc/direction"

module Days
  class Day15
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    Input = Data.define(:nested_array, :instructions)
    LogicError = Class.new(RuntimeError)

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

      def can_move?(_direction)
        raise LogicError, "Don't ask a #{self.class.name} to move"
      end
    end

    class Robot < Entity
      def to_s = "@"

      def move(direction)
        element_in_direction = @grid.value_at(@location + direction)
        element_in_direction.move(direction)
        super
      rescue RuntimeError => _e
        # do nothing
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

    class BoxHead < Entity
      attr_accessor :butt

      def to_s = "["

      def move(direction) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        case direction
        when Solution::EAST # buttwards
          element_in_direction = @grid.value_at(@location + (direction * 2))
          # move the eid to clear the path for the butt
          element_in_direction.move(direction)
          # move the butt to clear the path for the head
          butt.move(direction, cleared: true)
          # move the head
          super
        when Solution::WEST # headwards
          element_in_direction = @grid.value_at(@location + direction)
          # move the eid to clear the path for the head
          element_in_direction.move(direction)
          # move the head to clear the path for the butt
          super
          # move the butt
          butt.move(direction, cleared: true)
        else # north/south
          # check both before moving either
          raise "NO CAN DO" unless can_move?(direction)

          element_in_direction_head = @grid.value_at(@location + direction)
          element_in_direction_head.move(direction)

          element_in_direction_butt = @grid.value_at(butt.location + direction)
          element_in_direction_butt.move(direction)
          super
          butt.move(direction, cleared: true)
        end
      end

      def can_move?(direction)
        element_in_direction_head = @grid.value_at(@location + direction)
        element_in_direction_butt = @grid.value_at(butt.location + direction)

        [element_in_direction_head, element_in_direction_butt].all? do |element|
          case element
          when Space then true
          when Wall then false
          when BoxHead then element.can_move?(direction)
          when BoxButt then element.head.can_move?(direction)
          end
        end
      end

      def gps_coordinates
        (100 * @location.y) + @location.x
      end
    end

    class BoxButt < Entity
      attr_accessor :head

      def to_s = "]"

      def move(direction, cleared: false)
        if cleared # the way has been cleared
          super(direction)
        else
          head.move(direction)
        end
      end
    end

    class Solution
      WEST = AOC::Direction.west
      EAST = AOC::Direction.east
      NORTH = AOC::Direction.north
      SOUTH = AOC::Direction.south
      DIRECTIONS = {
        ">" => EAST,
        "<" => WEST,
        "^" => NORTH,
        "v" => SOUTH,
      }.freeze

      def initialize(nested_array, instructions) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
        @grid = AOC::Grid.new(nested_array)
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
            when "[" then BoxHead.new(location, @grid).tap { @boxes << it }
            when "]" then BoxButt.new(location, @grid).tap do |butt|
              head = @grid.value_at(location + WEST)
              butt.head = head
              head.butt = butt
            end
            end,
          )
        end
      end

      def run_simulation(steps: nil)
        # puts @grid
        @instructions.each.with_index do |instruction, idx|
          direction = DIRECTIONS[instruction]
          @robot.move(direction)

          # puts "Step: #{idx + 1}, Instruction: #{instruction}"
          # puts @grid
          break if steps && idx + 1 >= steps
        end
      end

      def sum_of_all_boxes_gps_coordinates
        @boxes.map(&:gps_coordinates).sum
      end
    end

    class SolutionB < Solution
      DOUBLE_MAPPING = {
        "@" => ["@", "."],
        "O" => ["[", "]"],
        "#" => ["#", "#"],
        "." => [".", "."],
      }.freeze

      def initialize(nested_array, instructions)
        super(double_wide(nested_array), instructions)
      end

      def double_wide(nested_array)
        nested_array.map { |row| row.flat_map { |cell| DOUBLE_MAPPING[cell] } }
      end
    end

    def parse_input
      map_str, instructions_str = puzzle_input.split("\n\n")
      nested_array = map_str.lines(chomp: true).map(&:chars)
      instructions = instructions_str.lines(chomp: true).join.chars
      Input.new(nested_array, instructions)
    end

    def part_a
      input = parse_input
      solution = Solution.new(input.nested_array, input.instructions)
      solution.run_simulation
      solution.sum_of_all_boxes_gps_coordinates.to_s
    end

    def part_b
      input = parse_input
      solution = SolutionB.new(input.nested_array, input.instructions)
      solution.run_simulation
      solution.sum_of_all_boxes_gps_coordinates.to_s
    end

    private

    attr_reader :puzzle_input
  end
end
