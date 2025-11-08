# frozen_string_literal: true

require_relative "../lib/aoc/dijkstra"
require_relative "../lib/aoc/direction"
require_relative "../lib/aoc/edge"
require_relative "../lib/aoc/grid"

module Days
  class Day16
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def parse_input
      AOC::Grid.new(@puzzle_input.lines(chomp: true).map(&:chars))
    end

    def part_a
      solution = Solution.new(parse_input)
      solution.lowest_score.to_s
      # 65436 in 0.8s
    end

    def part_b
      solution = Solution.new(parse_input)
      solution.num_tiles_in_best_paths.to_s
      # 489 in 26s
    end

    private

    attr_reader :puzzle_input

    class Solution
      Vertex = Data.define(:location, :direction) do
        def to_s
          "V(#{location.x},#{location.y},#{direction.x},#{direction.y})"
        end
      end

      NORTH = AOC::Direction.north
      SOUTH = AOC::Direction.south
      EAST = AOC::Direction.east
      WEST = AOC::Direction.west
      DIRECTIONS = [NORTH, EAST, SOUTH, WEST].freeze

      MOVE_COST = 1
      TURN_COST = 1000
      TURN_COSTS = {
        rotate90left: TURN_COST + MOVE_COST,
        itself: MOVE_COST,
        rotate90right: TURN_COST + MOVE_COST,
        flip: TURN_COST + TURN_COST + MOVE_COST,
      }.freeze

      def initialize(grid)
        @grid = grid
        @vertices = {} # Hash["locdir" => Vertex(loc,dir)]
        @edges = [] # Array[AOC::Edge(src_key,tgt_key,wgt)]
        @source_location = nil
        @target_location = nil
        build_graph
        # set_dot_options
        # write_dot
      end

      def source_vertex
        @source_vertex ||= Vertex.new(@source_location, EAST)
      end

      def lowest_score
        pathfinder = AOC::Dijkstra.new(@vertices.keys, @edges)
        result = pathfinder.generate_shortest_paths(source_vertex.to_s)

        target_distances = result.distances.select do |vertex_str, _shortest_distance|
          @vertices[vertex_str].location == @target_location
        end

        _, distance = target_distances.min_by(&:last)
        distance
      end

      def num_tiles_in_best_paths # rubocop:disable Metrics/AbcSize
        pathfinder = AOC::Dijkstra.new(@vertices.keys, @edges)
        result = pathfinder.generate_shortest_multipaths(source_vertex.to_s)

        target_distances = result.distances.select do |vertex_str, _shortest_distance|
          @vertices[vertex_str].location == @target_location
        end

        target, _distance = target_distances.min_by(&:last)

        paths = pathfinder.multipath(source_vertex.to_s, target, result.parents)
        paths.flat_map { |path| path.map { |v| @vertices[v].location } }
             .uniq
             .size
      end

      private

      def build_graph
        build_graph_vertices
        build_graph_edges
      end

      def build_graph_vertices
        @grid.each do |loc, char|
          next if char == "#"

          DIRECTIONS.each do |dir|
            v = Vertex.new(location: loc, direction: dir)
            @vertices[v.to_s] = v
          end

          @source_location = loc if char == "S"
          @target_location = loc if char == "E"
        end
      end

      def build_graph_edges
        @vertices.each_value do |source|
          next if ["#", "E"].include?(@grid.value_at(source.location))

          TURN_COSTS.each do |method, cost|
            next_dir = source.direction.send(method)
            target = Vertex.new(source.location + next_dir, next_dir)
            next if @grid.value_at(target.location) == "#"

            @edges << AOC::Edge.new(source.to_s, target.to_s, weight: cost)
          end
        end
      end
    end
  end
end
