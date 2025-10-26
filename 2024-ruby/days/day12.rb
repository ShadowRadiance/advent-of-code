# frozen_string_literal: true

require_relative "../lib/aoc/grid"
require_relative "../lib/aoc/direction"

module Days
  class Day12
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    class Solution
      class Plot
        def initialize(location:, plant:, news_neighbours:, region:, grid:)
          @location = location
          @plant = plant
          @news_neighbours = news_neighbours
          @region = region
          @grid = grid
        end
        attr_reader :location, :plant, :news_neighbours
        attr_accessor :region

        def to_s = "#{plant}-#{location}"
        def inspect = to_s

        def details
          [
            to_s,
            "- region: #{region&.id || 'nil'}",
            news_neighbours.map do |dir, neighbour|
              "- #{dir.to_s.rjust(5)}: #{neighbour || 'nil'}"
            end,
          ].join("\n  ")
        end

        def neighbours
          news_neighbours.values.compact
        end

        def corners
          # For each L of neighbours
          #   There is an exterior corner if neither neighbour is in the region.
          #   There is an interior corner if both neighbours are in, but their combined offset (the diagonal) is out
          corner_tests.sum do |keys, diagonal|
            next 1 if keys.all? do |key|
              other_region?(news_neighbours[key])
            end

            next 1 if keys.all? do |key|
              same_region?(news_neighbours[key]) && @grid.value_at(location + diagonal) != region.plant
            end

            0
          end
        end

        def same_region?(neighbour)
          neighbour&.region&.id == region.id
        end

        def other_region?(neighbour)
          !same_region?(neighbour)
        end

        def corner_tests
          [
            [%i[north east], AOC::Direction.north_east],
            [%i[east south], AOC::Direction.south_east],
            [%i[south west], AOC::Direction.south_west],
            [%i[west north], AOC::Direction.north_west],
          ]
        end
      end

      Fence = Data.define(:region_id, :location, :direction)
      Side = Struct.new(:region_id, :plant, :start_loc, :end_loc, :direction, :length) # rubocop:disable Lint/StructNewOverride

      class Region
        attr_reader :id, :plant, :plots, :fences, :sides

        def initialize(plant)
          @id = self.class.next_id
          @plant = plant
          @plots = []
          @fences = []
          @sides = []
        end

        def to_s = "#{id}/#{plant}: #{plots}"
        def inspect = to_s

        def area
          plots.length
        end

        def perimeter
          plots.sum do |plot|
            4 - plot.neighbours.filter { it.region.id == id }.length
          end
        end

        def num_sides
          # num_sides === num_corners
          plots.sum(&:corners)
        end

        def num_sides_worked_only_for_tests
          build_fences
          build_sides

          # puts fences
          # puts sides

          sides.length
        end

        def build_fences
          plots.each do |plot|
            plot.news_neighbours.each do |direction, neighbour|
              next if neighbour&.region&.id == id

              @fences << Fence.new(id, plot.location, direction)
            end
          end
        end

        def build_sides
          # collapse any fences that are part of the same "side"
          # that is adjacent to a side, pointing the same direction
          fences.each { |fence| collapse_into_side(fence) }
        end

        def collapse_into_side(fence) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
          found = false
          sides.each do |side|
            next unless side.direction == fence.direction

            if side.end_loc.cardinally_adjacent?(fence.location)
              side.end_loc = fence.location
              side.length += 1
              found = true
              break
            elsif side.start_loc.cardinally_adjacent?(fence.location)
              side.start_loc = fence.location
              side.length += 1
              found = true
              break
            end
          end

          return if found

          sides << Side.new(
            region_id: id,
            plant: plant,
            start_loc: fence.location,
            end_loc: fence.location,
            length: 1,
            direction: fence.direction,
          )
        end

        class << self
          def next_id
            @next_id = 0 unless defined?(@next_id)
            @next_id += 1
          end

          def reset_id
            @next_id = 0
          end
        end
      end

      def initialize(matrix)
        Region.reset_id
        @grid = AOC::Grid.new(matrix)
        @plots = []
        @plots_by_location = {}
        @regions = []

        initialize_plots
        link_plots
        build_regions
      end

      def initialize_plots
        @grid.each do |location, value|
          plot = Plot.new(
            location: location,
            plant: value,
            news_neighbours: empty_neighbours,
            region: nil,
            grid: grid,
          )
          @plots << plot
          @plots_by_location[location] = plot
        end
      end

      def link_plots
        @plots_by_location.each do |location, plot|
          news.each do |symbol, direction|
            neighbour_location = location + direction
            if neighbour_location.in_bounds?(@grid.bounds)
              plot.news_neighbours[symbol] = @plots_by_location[neighbour_location]
            end
          end
        end
      end

      def build_regions
        @plots.each do |plot|
          next if plot.region

          @regions << Region.new(plot.plant).tap do |region|
            flood_fill(plot, region)
          end
        end
      end

      def flood_fill(plot, region)
        subplots = [plot]
        until subplots.empty?
          subplot = subplots.shift
          next unless subplot.region.nil?
          next if subplot.plant != plot.plant

          subplot.region = region
          region.plots << subplot
          subplots.concat(subplot.neighbours)
        end
      end

      attr_reader :grid, :plots, :regions

      def news = { north: north, east: east, south: south, west: west }
      def empty_neighbours = { north: nil, east: nil, south: nil, west: nil }
      def north = AOC::Direction.north
      def east = AOC::Direction.east
      def south = AOC::Direction.south
      def west = AOC::Direction.west
    end

    def parse_input
      puzzle_input.lines(chomp: true).map(&:chars)
    end

    def part_a
      solution = Solution.new(parse_input)
      solution.regions
              .sum { it.area * it.perimeter }
              .to_s
      # 1424472 instant
    end

    def part_b
      solution = Solution.new(parse_input)
      solution.regions
              .sum { it.area * it.num_sides }
              .to_s
      # 870202 instant
    end

    private

    attr_reader :puzzle_input
  end
end
