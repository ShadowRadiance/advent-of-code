# frozen_string_literal: true

require_relative "../lib/aoc/bounds"
require_relative "../lib/aoc/location"

module Days
  class Day08
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def read_antennae_by_frequency(matrix)
      antennae = {}
      matrix.each_with_index do |row, row_idx|
        row.each_with_index do |cell, cell_idx|
          if cell != "."
            antennae[cell] ||= []
            antennae[cell] << AOC::Location.new(x: cell_idx, y: row_idx)
          end
        end
      end
      antennae
    end

    def generate_antinodes(antennae_by_frequency, bounds, extended: false)
      antinodes = Set.new

      antennae_by_frequency.each_value do |antenna_list|
        generate_antinodes_for_frequency(antenna_list, bounds, antinodes: antinodes, extended: extended)
      end

      antinodes
    end

    def generate_antinodes_for_frequency(antenna_list, bounds, antinodes:, extended: false)
      antenna_list.combination(2) do |first, second|
        vector = second - first
        if extended
          create_all_antinodes(vector, first, bounds, antinodes: antinodes)
        else
          create_antinode_pair(vector, first, second, bounds, antinodes: antinodes)
        end
      end
    end

    def create_antinode_pair(vector, first, second, bounds, antinodes:)
      potential_antinode = first - vector
      antinodes << potential_antinode if potential_antinode.in_bounds?(bounds)
      potential_antinode = second + vector
      antinodes << potential_antinode if potential_antinode.in_bounds?(bounds)
    end

    def create_all_antinodes(vector, first, bounds, antinodes:)
      antinodes << first

      # walk along the +vector until it's !in_bounds?
      create_all_antinodes_positive(vector, first, bounds, antinodes: antinodes)
      # walk along the -vector until it's !in_bounds?
      create_all_antinodes_positive(-vector, first, bounds, antinodes: antinodes)
    end

    def create_all_antinodes_positive(vector, first, bounds, antinodes:)
      next_antinode = first + vector
      while next_antinode.in_bounds?(bounds)
        antinodes << next_antinode
        next_antinode += vector
      end
    end

    def shared_solution(extended:)
      matrix = puzzle_input.lines(chomp: true).map(&:chars)
      bounds = AOC::Bounds.new(
        min_x: 0,
        min_y: 0,
        max_x: matrix.first.length - 1,
        max_y: matrix.length - 1,
      )
      antennae_by_frequency = read_antennae_by_frequency(matrix)

      antinodes = generate_antinodes(antennae_by_frequency, bounds, extended: extended)

      antinodes.length.to_s
    end

    def part_a
      # GIVEN a grid of antennae (any digit, lowercase letter, or uppercase letter)
      # WHEN antinodes are generated
      # |  | an antinode is generated at any point that is perfectly in line with two antennae of the same frequency
      # |  | - but only when one of the antennas is twice as far away as the other
      # |  |   for each antenae pair [A,B]
      # |  |     determine vector AB => B-A => Vector.new(x: B.x-A.x, y: B.y-A.y)
      # |  |     create antinode at A-AB => A+A-B => Vector.new(x: 2*A.x-B.x, y: 2*A.y-B.y) if that is in bounds
      # |  |     create antinode at B+AB => B+B-A => Vector.new(x: 2*B.x-A.y, y: 2*B.y-A.y) if that is in bounds
      # |  |   end
      # |  | antinodes may overlap each other or antennae
      # THEN count the locations where there are antinodes
      shared_solution(extended: false)
    end

    def part_b
      # Same setup, except:
      # an antinode occurs at any grid position exactly in line with at least
      # two antennas of the same frequency, regardless of distance
      #
      # That is, for any antennae pair [A,B]
      #            determine vector AB => B-A => Vector.new(x: B.x-A.x, y: B.y-A.y)
      #            instead of just the points one vector away from the pair in each direction
      #            create antinodes at A+n(AB) for all n ∈ ℤ
      #          end
      # obviously, n is limited to values s.t. A+n(AB) is within bounds
      shared_solution(extended: true)
    end

    private

    attr_reader :puzzle_input
  end
end
