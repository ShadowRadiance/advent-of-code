# frozen_string_literal: true

require_relative "../../lib/bounds"
require_relative "../../lib/location"

module Days
  class Day06
    class Map
      def initialize(matrix)
        @matrix = matrix
        @num_rows = matrix.length
        @num_cols = matrix&.first&.length || 0
      end

      attr_reader :num_rows, :num_cols

      # returns Location|nil
      def find_char(char)
        num_rows.times do |row_idx|
          num_cols.times do |col_idx|
            return Location.new(x: col_idx, y: row_idx) if @matrix[row_idx][col_idx] == char
          end
        end
        nil
      end

      def char_at_loc(loc)
        return nil unless loc.in_bounds?(bounds)

        @matrix[loc.y][loc.x]
      end

      def set_char_at_loc(loc, char)
        raise unless loc.in_bounds?(bounds)

        @matrix[loc.y][loc.x] = char
      end

      def count_chars(char)
        @matrix.sum { |r| r.count(char) }
      end

      def bounds
        Bounds.new(
          min_x: 0,
          min_y: 0,
          max_x: num_cols - 1,
          max_y: num_rows - 1,
        )
      end
    end
  end
end
