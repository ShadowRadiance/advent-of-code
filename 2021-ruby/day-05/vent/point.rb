module Vent
  class Point
    attr_reader :x, :y
    def initialize(x,y)
      @x = x
      @y = y
    end

    def ==(other)
      x == other.x && y == other.y
    end
  end
end