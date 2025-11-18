# frozen_string_literal: true

require_relative "../lib/aoc/grid"
require_relative "../lib/aoc/bounds"
require_relative "../lib/aoc/location"
require_relative "../lib/aoc/direction"

module Days
  class Day14 # rubocop:disable Metrics/ClassLength
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    LINE_PARSER = /p=(\d+),(\d+)\ v=(-?\d+),(-?\d+)/
    Robot = Struct.new(:location, :direction, keyword_init: true)

    def robot_from_description(line)
      # p=0,4 v=3,-3
      matches = LINE_PARSER.match(line)
      Robot.new(
        location: AOC::Location.new(x: matches[1].to_i, y: matches[2].to_i),
        direction: AOC::Direction.new(x: matches[3].to_i, y: matches[4].to_i),
      )
    end

    def parse_input
      puzzle_input.lines(chomp: true).map { robot_from_description(it) }
    end

    def teleport_wrap(location)
      AOC::Location.new(location.x % @max_x, location.y % @max_y)
    end

    def walk_robot(robot, times)
      robot.location = teleport_wrap(robot.location + (robot.direction * times))
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
      robots.each { |robot| walk_robot(robot, 100) }

      quadrants.map { count_robots_in_quadrant(it, robots) }
               .reduce(:*)
               .to_s
    end

    def part_b(testing: false)
      # During the bathroom break, someone notices that these robots seem
      # awfully similar to ones built and used at the North Pole. If they're
      # the same type of robots, they should have a hard-coded Easter egg:
      # very rarely, most of the robots should arrange themselves into a
      # picture of a Christmas tree.
      # What is the fewest number of seconds that must elapse for the robots to display the Easter egg?
      #
      # WAT? How do we know when it's christmas tree enough???

      # https://www.reddit.com/r/adventofcode/comments/1hdw23y/2024_day_14_part_2_what/
      # redditor suggested - look for standard deviations from center
      #                    - min(sum(stddev of robot from center))

      @max_x = testing ? 11 : 101
      @max_y = testing ? 7 : 103

      grid = AOC::Grid.new(Array.new(@max_y) { Array.new(@max_x, 0) })
      robots = parse_input
      robots.each do |robot|
        grid.set_value_at(robot.location, grid.value_at(robot.location) + 1)
      end

      result = search_for_xmas_trees(grid, robots)

      return "PENDING_B" if defined?(RSpec)

      result
      # 7501 in 30s
    end

    def grid_string(grid)
      grid.to_s.gsub("0", ".")
    end

    def search_for_xmas_trees(grid, robots) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      max_seconds = @max_x * @max_y
      center = AOC::Location.new((@max_x + 1) / 2, (@max_y + 1) / 2)

      initial_grid = grid_string(grid)

      standard_deviations = []

      max_seconds.times do |second|
        deviations = []
        robots.each do |robot|
          grid.set_value_at(robot.location, grid.value_at(robot.location) - 1)
          walk_robot(robot, 1)
          grid.set_value_at(robot.location, grid.value_at(robot.location) + 1)
          deviations << (robot.location - center).length
        end
        standard_deviation = Math.sqrt(deviations.map { it * it }.sum / deviations.size)
        standard_deviations <<
          { sd: standard_deviation, second: second, grid: grid_string(grid) }
      end
      final_grid = grid.to_s.gsub("0", ".")
      raise "whoops" unless final_grid == initial_grid

      # puts grid_string(grid_at_lsd) unless defined?(RSpec)

      standard_deviations.sort_by! { it[:sd] }
      best = standard_deviations[0]

      puts "#{best[:second]} #{best[:sd]}" unless defined?(RSpec)
      puts best[:grid] unless defined?(RSpec)

      # 7501 is too low (seconds was 0-based instead of 1-based)
      # 7502 is the right answer
      best[:second] - 1
    end

    private

    attr_reader :puzzle_input
  end
end
