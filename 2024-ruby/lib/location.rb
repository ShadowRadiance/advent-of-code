# frozen_string_literal: true

require_relative "vector"

class Location < Vector
  def in_bounds?(bounds)
    bounds.cover?(x: x, y: y)
  end
end
