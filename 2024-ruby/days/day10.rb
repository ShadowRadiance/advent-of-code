# frozen_string_literal: true

require_relative "../lib/location"
require_relative "../lib/direction"
require_relative "../lib/grid"

module Days
  class Day10
    class SolutionA
      Trail = Data.define(:location, :set_of_nines) do
        def inspect
          "#{location}S#{set_of_nines.size}"
        end

        def score
          set_of_nines.size
        end
      end

      def initialize(puzzle_input)
        @matrix = puzzle_input.lines(chomp: true).map { it.chars.map(&:to_i) }
        @grid = Grid.new(matrix)
        @locations = Array.new(10) { [] }
        @trails = Array.new(10)
        parse_locations
      end

      def news
        @news ||= [north, east, west, south]
      end

      def solve
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

        trails[9] = locations[9].map { |loc| Trail.new(loc, [loc].to_set) }

        8.downto(0) do |height|
          trails[height] = locations[height].map { |loc| trail_for(loc, height) }
        end
      end

      def trail_for(loc, height)
        set = Set.new
        news.each { |dir| set += nines_for(loc + dir, height) }
        Trail.new(loc, set)
      end

      def nines_for(loc, height)
        step_up_idx = locations[height + 1].index(loc)
        return Set.new if step_up_idx.nil?

        trails[height + 1][step_up_idx].set_of_nines
      end

      def parse_locations
        matrix.each_index do |y|
          matrix.first.each_index do |x|
            value = matrix[y][x]
            locations[value] << Location.new(x: x, y: y)
          end
        end
      end

      def north = Direction.north
      def south = Direction.south
      def east = Direction.east
      def west = Direction.west

      attr_reader :grid, :matrix, :locations, :trails
    end

    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def part_a
      SolutionA.new(puzzle_input).solve
    end

    def part_b
      "PENDING_B"
    end

    private

    attr_reader :puzzle_input
  end
end
