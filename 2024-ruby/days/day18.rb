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

      def pre_drop(bytes)
        @falling_bytes[0...bytes].each do |byte|
          @grid.set_value_at(byte, "#")
        end
        @falling_bytes = @falling_bytes[bytes..]
      end

      def drop
        byte = @falling_bytes.shift
        @grid.set_value_at(byte, "#")
        byte
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
      # find shortest path after dropping 1024 (or 12 if testing) bytes
      params = setup(testing)
      params.solver.pre_drop(params.drop)
      params.solver.shortest_path_length(params.source, params.target).to_s
      # 312 in 0s
    end

    def part_b(testing: false)
      # determine the first byte that will cut off the path to the exit
      params = setup(testing)
      params.solver.pre_drop(params.drop)

      part_b_brute_force(params)
    end

    Params = Data.define(:height, :width, :drop, :solver, :source, :target)

    def setup(testing)
      height = testing ? 7 : 71
      width = testing ? 7 : 71
      Params.new(
        height: height,
        width: width,
        drop: testing ? 12 : 1024,
        solver: Solver.new(puzzle_input, height, width),
        source: AOC::Location.new(0, 0),
        target: AOC::Location.new(width - 1, height - 1),
      )
    end

    def part_b_brute_force(params)
      # brute force:
      #   drop each byte
      #   check for shortest path
      #   if Float::INFINITY then return byte

      # we know we can drop the first (12/1024) from test description and from part a
      params.solver.pre_drop(params.drop)

      spl = nil
      until spl == Float::INFINITY
        last_location = params.solver.drop
        spl = params.solver.shortest_path_length(params.source, params.target)
        # puts "SPL: #{spl}"
      end
      "#{last_location.x},#{last_location.y}"

      # 28,26 in 3m36s
    end

    private

    attr_reader :puzzle_input
  end
end
