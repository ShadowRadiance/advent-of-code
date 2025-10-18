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
      # find all XMASes
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
      # find all MAS pairs in the shape of an X
      # eg. M.S   ||   S.M   ||   M.M   ||   S.S
      #     .A.   ||   .A.   ||   .A.   ||   .A.
      #     M.S   ||   S.M   ||   S.S   ||   M.M
      results = @matrix.flat_map.with_index do |row, row_idx|
        row.filter_map.with_index do |letter, col_idx|
          next nil unless letter == "A"

          location = Location.new(x: col_idx, y: row_idx)
          {
            location: location,
            x_mases: count_crossed_mases(location),
          }
        end
      end
      results.sum { it[:x_mases] || 0 }.to_s
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

    def crossed_mas?(a_loc)
      crossed_mas_groups(a_loc).each do |group|
        return true if group[:m_locs].all? { @matrix[it.y][it.x] == "M" } &&
                       group[:s_locs].all? { @matrix[it.y][it.x] == "S" }
      end
      false
    end

    private

    def crossed_mas_groups(a_loc)
      # eg. M.S   ||   S.M   ||   M.M   ||   S.S
      #     .A.   ||   .A.   ||   .A.   ||   .A.
      #     M.S   ||   S.M   ||   S.S   ||   M.M

      north_east = a_loc + Direction.compass_directions[:north_east]
      north_west = a_loc + Direction.compass_directions[:north_west]
      south_east = a_loc + Direction.compass_directions[:south_east]
      south_west = a_loc + Direction.compass_directions[:south_west]

      [north_east, north_west, south_east, south_west].each do |loc|
        ensure_location_readable(loc)
      end

      [
        { m_locs: [north_east, south_east], s_locs: [north_west, south_west] },
        { m_locs: [north_west, south_west], s_locs: [north_east, south_east] },
        { m_locs: [north_east, north_west], s_locs: [south_east, south_west] },
        { m_locs: [south_east, south_west], s_locs: [north_east, north_west] },
      ]
    end

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

    def count_crossed_mases(a_loc)
      crossed_mas?(a_loc) ? 1 : 0
    rescue OutOfBoundsError => _e
      nil
    end

    attr_reader :puzzle_input
  end
end
