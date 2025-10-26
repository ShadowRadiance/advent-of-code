# frozen_string_literal: true

require_relative "../lib/aoc/grid"
require_relative "../lib/aoc/bounds"
require_relative "../lib/aoc/location"
require_relative "../lib/aoc/direction"

module Days
  class Day14
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    LINE_PARSER = /p=(\d+),(\d+)\ v=(-?\d+),(-?\d+)/
    Robot = Data.define(:location, :direction)

    def robot_from_description(line)
      # p=0,4 v=3,-3
      matches = LINE_PARSER.match(line)
      Robot.new(
        AOC::Location.new(x: matches[1].to_i, y: matches[2].to_i),
        AOC::Direction.new(x: matches[3].to_i, y: matches[4].to_i),
      )
    end

    def parse_input
      puzzle_input.lines(chomp: true).map { robot_from_description(it) }
    end

    def teleport_wrap(location)
      AOC::Location.new(location.x % @max_x, location.y % @max_y)
    end

    def walk_robot(robot, times)
      Robot.new(
        location: teleport_wrap(robot.location + (robot.direction * times)),
        direction: robot.direction,
      )
    end

    def count_robots_in_quadrant(quadrant, robots)
      robots.count { it.location.in_bounds?(quadrant) }
    end

    def quadrants
      half_x = (@max_x - 1) / 2 # 11 => 5
      half_y = (@max_y - 1) / 2 #  7 => 3

      [
        AOC::Bounds.new(
          min_x: 0,
          max_x: half_x - 1,
          min_y: 0,
          max_y: half_y - 1,
        ),
        AOC::Bounds.new(
          min_x: half_x + 1,
          max_x: @max_x,
          min_y: 0,
          max_y: half_y - 1,
        ),
        AOC::Bounds.new(
          min_x: 0,
          max_x: half_x - 1,
          min_y: half_y + 1,
          max_y: @max_y,
        ),
        AOC::Bounds.new(
          min_x: half_x + 1,
          max_x: @max_x,
          min_y: half_y + 1,
          max_y: @max_y,
        ),
      ]
    end

    def part_a(testing: false)
      @max_x = testing ? 11 : 101
      @max_y = testing ? 7 : 103
      robots = parse_input
      robots = robots.map { |robot| walk_robot(robot, 100) }

      quadrants.map { count_robots_in_quadrant(it, robots) }
               .reduce(:*)
               .to_s
    end

    def part_b
      "PENDING_B"
    end

    private

    attr_reader :puzzle_input
  end
end
