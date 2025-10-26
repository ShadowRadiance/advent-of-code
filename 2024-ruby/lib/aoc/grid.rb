# frozen_string_literal: true

require_relative "bounds"
require_relative "location"

module AOC
  class Grid
    def initialize(matrix)
      @matrix = matrix
      @num_rows = matrix.length
      @num_cols = matrix&.first&.length || 0
    end

    attr_reader :num_rows, :num_cols

    def inspect
      "Grid:\n#{@matrix.map { it.join(' ') }.join("\n")}"
    end

    def to_s
      inspect
    end

    def each
      num_rows.times do |row_idx|
        num_cols.times do |col_idx|
          yield [Location.new(x: col_idx, y: row_idx), @matrix[row_idx][col_idx]]
        end
      end
    end

    # returns Location|nil
    def find(value)
      num_rows.times do |row_idx|
        num_cols.times do |col_idx|
          return Location.new(x: col_idx, y: row_idx) if @matrix[row_idx][col_idx] == value
        end
      end
      nil
    end

    def find_all(value)
      result = []
      num_rows.times do |row_idx|
        num_cols.times do |col_idx|
          result << Location.new(x: col_idx, y: row_idx) if @matrix[row_idx][col_idx] == value
        end
      end
      result
    end

    def value_at(loc)
      return nil unless loc.in_bounds?(bounds)

      @matrix[loc.y][loc.x]
    end

    def set_value_at(loc, value)
      raise unless loc.in_bounds?(bounds)

      @matrix[loc.y][loc.x] = value
    end

    def count_values(value)
      @matrix.sum { |r| r.count(value) }
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
