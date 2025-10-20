# frozen_string_literal: true

require_relative "../lib/bounds"
require_relative "../lib/location"

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
            antennae[cell] << Location.new(x: cell_idx, y: row_idx)
          end
        end
      end
      antennae
    end

    def generate_antinodes(antennae_by_frequency, bounds)
      antinodes = Set.new

      antennae_by_frequency.each do |frequency, antenna_list|
        antinodes.merge(generate_antinodes_for_frequency(frequency, antenna_list, bounds))
      end

      antinodes
    end

    def generate_antinodes_for_frequency(_frequency, antenna_list, bounds)
      antinodes = Set.new
      antenna_list.combination(2) do |first, second|
        vector = second - first
        potential_antinode = first - vector
        antinodes << potential_antinode if potential_antinode.in_bounds?(bounds)
        potential_antinode = second + vector
        antinodes << potential_antinode if potential_antinode.in_bounds?(bounds)
      end
      antinodes
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
      matrix = puzzle_input.lines(chomp: true).map(&:chars)
      bounds = Bounds.new(
        min_x: 0,
        min_y: 0,
        max_x: matrix.first.length - 1,
        max_y: matrix.length - 1,
      )
      antennae_by_frequency = read_antennae_by_frequency(matrix)

      antinodes = generate_antinodes(antennae_by_frequency, bounds)

      antinodes.length.to_s
    end

    def part_b
      "PENDING_B"
    end

    private

    attr_reader :puzzle_input
  end
end
