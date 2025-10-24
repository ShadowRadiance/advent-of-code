# frozen_string_literal: true

require_relative "../lib/grid"
require_relative "../lib/direction"

module Days
  class Day12
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    class Solution
      Plot = Struct.new(:location, :plant, :news_neighbours, :region, keyword_init: true) do
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
      end

      class Region
        attr_reader :id, :plant, :plots

        def initialize(plant)
          @id = self.class.next_id
          @plant = plant
          @plots = []
        end

        def to_s = "#{id}/#{plant}: #{plots}"
        def inspect = to_s

        def area
          plots.length
        end

        def perimeter
          plots.sum do |plot|
            4 - plot.neighbours.filter { it.plant == plant }.length
          end
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
        @grid = Grid.new(matrix)
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
      def north = Direction.north
      def east = Direction.east
      def south = Direction.south
      def west = Direction.west
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
      "PENDING_B"
    end

    private

    attr_reader :puzzle_input
  end
end
