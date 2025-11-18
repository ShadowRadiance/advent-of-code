# frozen_string_literal: true

require_relative "../lib/aoc/direction"
require_relative "../lib/aoc/edge"
require_relative "../lib/aoc/graph"
require_relative "../lib/aoc/grid"
require_relative "../lib/aoc/location"

require "debug"

module Days
  class Day20
    class Solver
      # up down left right cost 1ps each
      # cannot pass through walls
      # there is only one path from the start to the end

      def initialize(puzzle_input)
        @grid = AOC::Grid.new(puzzle_input.lines(chomp: true).map(&:chars))
        @start = @grid.find("S")
        @finish = @grid.find("E")
        locations = @grid.find_all(".") + [@start, @finish]
        @locations = locations.to_h { |loc| [loc.to_s, loc] }
        @graph = build_graph
        @no_cheat_path = @graph.dijkstra_shortest_path(@start.to_s, @finish.to_s)
      end

      def directions
        @directions ||= AOC::Direction.cardinal_directions.values
      end

      def double_directions
        @double_directions ||= directions.to_h { |direction| [direction, direction * 2] }
      end

      def build_graph
        vertices = @locations.keys
        edges = @locations.values.flat_map do |location|
          directions.filter_map do |direction|
            next_location = location + direction
            next unless %w[. S E].include?(@grid.value_at(next_location))

            AOC::Edge.new(location.to_s, next_location.to_s)
          end
        end
        AOC::Graph.new(vertices, edges)
      end

      def number_of_cheats_that_save_at_least(save_minimum)
        cheats_by_savings.select { |k, _v| k >= save_minimum }
                         .values
                         .sum
      end

      # @return [Hash<Integer,Integer>]
      def cheats_by_savings
        # walk the original path.
        cheats_by_savings = Hash.new(0)
        @no_cheat_path.each_with_index do |vertex, current_index|
          cheat_savings_at_index(@locations[vertex], current_index).each do |savings|
            cheats_by_savings[savings] += 1
          end
        end
        cheats_by_savings
      end

      def cheat_savings_at_index(location, current_index)
        # at each point check each of the four directions
        #   if loc+dir is a wall AND loc+(dir*2) is further along the path
        #     we found a shortcut/cheat
        #     determine the saved distance
        #       distance_so_far + 2 + remaining_distance_to_end
        directions.filter_map do |direction|
          next unless wall?(location + direction)

          index_of_location_in_path = @no_cheat_path.index((location + x2(direction)).to_s)
          next if index_of_location_in_path.nil? || index_of_location_in_path <= current_index

          savings(current_index, index_of_location_in_path)
        end
      end

      def savings(skip_from_index, skip_to_index)
        (skip_to_index - skip_from_index) - 2
      end

      def x2(direction)
        double_directions[direction]
      end

      def wall?(location)
        @grid.value_at(location) == "#"
      end
    end

    class SolverB < Solver
      def cheats_by_savings
        # for each pair of locations on the path
        # -- can we jump from location_a to location_b? (manhattan_distance <= 20)
        # -- -- how much is the savings for that jump?
        cheats_by_savings = Hash.new(0)
        @no_cheat_path.each_with_index do |from_vertex, from_index|
          @no_cheat_path.each_with_index do |to_vertex, to_index|
            next if to_index <= from_index # same location or earlier location

            d = @locations[from_vertex].manhattan_distance(@locations[to_vertex])
            next unless d <= 20 # too long to jump

            cheats_by_savings[savings(from_index, to_index, d)] += 1
          end
        end
        cheats_by_savings
      end

      def savings(skip_from_index, skip_to_index, distance)
        (skip_to_index - skip_from_index) - distance
      end
    end

    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def part_a(save_minimum: 100)
      solver = Solver.new(@puzzle_input)
      solver.number_of_cheats_that_save_at_least(save_minimum)
    end

    def part_b(save_minimum: 100)
      solver = SolverB.new(@puzzle_input)
      solver.number_of_cheats_that_save_at_least(save_minimum)
      # 1014683 in 11s
    end
  end
end
