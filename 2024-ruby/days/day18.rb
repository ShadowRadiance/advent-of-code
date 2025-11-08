# frozen_string_literal: true

require_relative "../lib/aoc/dijkstra"
require_relative "../lib/aoc/direction"
require_relative "../lib/aoc/edge"
require_relative "../lib/aoc/grid"
require_relative "../lib/aoc/location"

module Days
  class Day18
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    class Solver
      def initialize(puzzle_input, height, width)
        @falling_bytes = puzzle_input.lines(chomp: true).map do |line|
          AOC::Location.new(*line.split(",").map(&:to_i))
        end
        @grid = AOC::Grid.new(Array.new(height) { Array.new(width, ".") })
      end
      attr_reader :falling_bytes, :grid

      def drop(bytes)
        @falling_bytes[0...bytes].each do |byte|
          @grid.set_value_at(byte, "#")
        end
      end

      def shortest_path_length(source, target)
        vertices, edges = grid_to_graph(@grid)
        dijkstra = AOC::Dijkstra.new(vertices.keys, edges)
        result = dijkstra.generate_shortest_paths(key(source))
        result.distances[key(target)]
      end

      def grid_to_graph(grid)
        vertices = {}
        edges = []
        grid.each do |location, _| # rubocop:disable Style/HashEachMethods
          vertices[key(location)] = location
          AOC::Direction.cardinal_directions.each_value do |dir|
            maybe_target = location + dir
            edges << AOC::Edge.new(key(location), key(maybe_target)) if grid.value_at(maybe_target) == "."
          end
        end
        [vertices, edges]
      end

      def key(location)
        location.to_s
      end
    end

    def part_a(testing: false)
      height = testing ? 7 : 71
      width = testing ? 7 : 71
      drop = testing ? 12 : 1024
      solver = Solver.new(puzzle_input, height, width)

      solver.drop(drop)
      solver.shortest_path_length(
        AOC::Location.new(0, 0),
        AOC::Location.new(width - 1, height - 1),
      ).to_s
      # 312 in 0s
    end

    def part_b
      "PENDING_B"
    end

    private

    attr_reader :puzzle_input
  end
end
