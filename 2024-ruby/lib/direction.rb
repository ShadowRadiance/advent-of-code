# frozen_string_literal: true

require_relative "vector"

class Direction < Vector
  def self.compass_directions
    {
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
end
