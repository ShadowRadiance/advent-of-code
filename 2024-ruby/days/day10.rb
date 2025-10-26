# frozen_string_literal: true

require_relative "../lib/aoc/location"
require_relative "../lib/aoc/direction"
require_relative "../lib/aoc/grid"

module Days
  class Day10
    class SolutionA
      Trail = Data.define(:location, :nines, :paths) do
        def inspect
          "#{location}S#{nines.size}"
        end

        def score
          nines.size
        end

        def rating
          paths.size
        end
      end

      def initialize(puzzle_input)
        @matrix = puzzle_input.lines(chomp: true).map { it.chars.map(&:to_i) }
        @grid = AOC::Grid.new(matrix)
        @locations = Array.new(10) { [] }
        @trails = Array.new(10)
        parse_locations
      end

      def directions
        @directions ||= [north, east, west, south]
      end

      def solve
        # score: number of nines reached by trailhead (trails[0])
        follow_nines_down

        trails[0].map(&:score).sum.to_s
      end

      private

      def follow_nines_down
        # trail9s => all the 9s
        # trail8s => all the 8s next to a trail9, remember which 9s
        # trail7s => all the 7s next to a trail8, remember which 9s from the 8s
        # ...
        # trail0s => all the 0s next to a trail2, remember which 9s from the 2s
        # trailheads => all the 0s next to a trail1, remember which 9s from the 1s

        trails[9] = locations[9].map { |loc| Trail.new(loc, [loc].to_set, [[loc]].to_set) }

        8.downto(0) do |height|
          trails[height] = locations[height].map { |loc| trail_for(loc, height) }
        end
      end

      def trail_for(loc, height) # rubocop:disable Metrics/AbcSize
        nines = Set.new
        paths_to_the_top = Set.new

        # for each direction
        #   if the loc+dir is in the locations[height+1]
        #     add one path to the top for each path in trails[height + 1][step_up_idx].paths
        #     by taking the path and appending this loc to it
        #     (the paths will be reversed but meh)

        directions.each do |dir|
          step_up_idx = locations[height + 1].index(loc + dir)
          next if step_up_idx.nil?

          nines += trails[height + 1][step_up_idx].nines
          paths_to_the_top += trails[height + 1][step_up_idx].paths.map { |path| path + [loc] }
        end
        Trail.new(loc, nines, paths_to_the_top)
      end

      def parse_locations
        matrix.each_index do |y|
          matrix.first.each_index do |x|
            value = matrix[y][x]
            locations[value] << AOC::Location.new(x: x, y: y)
          end
        end
      end

      def north = AOC::Direction.north
      def south = AOC::Direction.south
      def east = AOC::Direction.east
      def west = AOC::Direction.west

      attr_reader :grid, :matrix, :locations, :trails
    end

    class SolutionB < SolutionA
      def solve
        follow_nines_down

        # rating: number of distinct trails which begin at that trailhead
        trails[0].map(&:rating).sum.to_s
      end
    end

    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def part_a
      SolutionA.new(puzzle_input).solve
    end

    def part_b
      SolutionB.new(puzzle_input).solve
    end

    private

    attr_reader :puzzle_input
  end
end
