# frozen_string_literal: true

require_relative "vector"

class Direction < Vector
  def self.compass_directions
    @compass_directions ||= {
      north: Direction.new(x: +0, y: -1),
      north_east: Direction.new(x: +1, y: -1),
      east: Direction.new(x: +1, y: +0),
      south_east: Direction.new(x: +1, y: +1),
      south: Direction.new(x: +0, y: +1),
      south_west: Direction.new(x: -1, y: +1),
      west: Direction.new(x: -1, y: +0),
      north_west: Direction.new(x: -1, y: -1),
    }
  end

  def self.from_char(char)
    case char
    when "^" then compass_directions[:north]
    when ">" then compass_directions[:east]
    when "v" then compass_directions[:south]
    when "<" then compass_directions[:west]
    else raise "Unknown direction"
    end
  end

  def to_c
    case self
    when compass_directions[:north] then "^"
    when compass_directions[:east] then ">"
    when compass_directions[:south] then "v"
    when compass_directions[:west] then "<"
    else raise "Unknown direction"
    end
  end

  def rotate90right
    Direction.new(x: -y, y: x)
  end

  def rotate90left
    Direction.new(x: y, y: -x)
  end
end
