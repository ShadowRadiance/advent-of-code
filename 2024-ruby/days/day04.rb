# frozen_string_literal: true

require_relative "../lib/location"
require_relative "../lib/direction"
require_relative "../lib/bounds"

module Days
  class Day04
    class OutOfBoundsError < RuntimeError; end

    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
      @matrix = parse_input
      @matrix_bounds = Bounds.new(
        min_x: 0, min_y: 0,
        max_x: (@matrix.first.length - 1),
        max_y: @matrix.length - 1,
      )
    end

    def part_a
      results = @matrix.flat_map.with_index do |row, row_idx|
        row.filter_map.with_index do |letter, col_idx|
          next nil unless letter == "X"

          location = Location.new(x: col_idx, y: row_idx)
          {
            location: location,
            xmases: count_xmases(location),
          }
        end
      end
      results.sum { it[:xmases] }.to_s
    end

    def part_b
      "PENDING-B"
    end

    def parse_input
      puzzle_input.lines(chomp: true).map(&:chars)
    end

    def xmas_in_direction?(ex_loc, direction)
      x_loc = ex_loc + (direction * 0)
      m_loc = ex_loc + (direction * 1)
      a_loc = ex_loc + (direction * 2)
      s_loc = ex_loc + (direction * 3)

      ensure_location_readable(s_loc)

      mas_match?(x_loc, m_loc, a_loc, s_loc)
    end

    private

    def mas_match?(_x_loc, m_loc, a_loc, s_loc)
      # @matrix[x_loc.y][x_loc.x] == "X" &&
      @matrix[m_loc.y][m_loc.x] == "M" &&
        @matrix[a_loc.y][a_loc.x] == "A" &&
        @matrix[s_loc.y][s_loc.x] == "S"
    end

    def ensure_location_readable(loc)
      raise OutOfBoundsError, "#{loc} is outside of #{@matrix_bounds}" unless loc.in_bounds?(@matrix_bounds)
    end

    def count_xmases(ex_loc)
      counts = Direction.compass_directions.values.map do |direction|
        xmas_in_direction?(ex_loc, direction) ? 1 : 0
      rescue OutOfBoundsError => _e
        nil
      end
      counts.compact.sum
    end

    attr_reader :puzzle_input
  end
end
