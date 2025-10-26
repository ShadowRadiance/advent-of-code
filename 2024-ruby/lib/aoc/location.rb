# frozen_string_literal: true

require_relative "vector"

module AOC
  class Location < Vector
    def in_bounds?(bounds)
      bounds.cover?(x: x, y: y)
    end

    def inspect
      "@(#{x},#{y})"
    end

    def adjacent?(other)
      cardinally_adjacent?(other) || diagonally_adjacent?(other)
    end

    def diagonally_adjacent?(other)
      (other.x == x + 1 && (other.y == y + 1 || other.y == y - 1)) ||
        (other.x == x - 1 && (other.y == y + 1 || other.y == y - 1))
    end

    def horizontally_adjacent?(other)
      return false if other.y != y

      other.x == x + 1 || other.x == x - 1
    end

    def vertically_adjacent?(other)
      return false if other.x != x

      other.y == y + 1 || other.y == y - 1
    end

    def cardinally_adjacent?(other)
      horizontally_adjacent?(other) || vertically_adjacent?(other)
    end
  end
end
