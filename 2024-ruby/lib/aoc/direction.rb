# frozen_string_literal: true

require_relative "vector"

module AOC
  class Direction < Vector
    def inspect
      "D(#{x},#{y})"
    end

    def self.compass_directions
      {
        north: north,
        north_east: north_east,
        east: east,
        south_east: south_east,
        south: south,
        south_west: south_west,
        west: west,
        north_west: north_west,
      }
    end

    def self.from_char(char)
      case char
      when "^" then Direction.north
      when ">" then Direction.east
      when "v" then Direction.south
      when "<" then Direction.west
      else raise "Unknown direction"
      end
    end

    def to_c
      case itself
      when Direction.north then "^"
      when Direction.east then ">"
      when Direction.south then "v"
      when Direction.west then "<"
      else raise "Unknown direction"
      end
    end

    def rotate90right
      Direction.new(x: -y, y: x)
    end

    def rotate90left
      Direction.new(x: y, y: -x)
    end

    def flip
      Direction.new(x: -x, y: -y)
    end

    def self.north
      @north ||= Direction.new(x: +0, y: -1)
    end

    def self.north_east
      @north_east ||= Direction.new(x: +1, y: -1)
    end

    def self.east
      @east ||= Direction.new(x: +1, y: +0)
    end

    def self.south_east
      @south_east ||= Direction.new(x: +1, y: +1)
    end

    def self.south
      @south ||= Direction.new(x: +0, y: +1)
    end

    def self.south_west
      @south_west ||= Direction.new(x: -1, y: +1)
    end

    def self.west
      @west ||= Direction.new(x: -1, y: +0)
    end

    def self.north_west
      @north_west ||= Direction.new(x: -1, y: -1)
    end
  end
end
