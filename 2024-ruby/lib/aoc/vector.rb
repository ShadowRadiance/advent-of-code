# frozen_string_literal: true

module AOC
  Vector = Data.define(:x, :y) do
    def inspect
      "V(#{x},#{y})"
    end

    def to_s
      inspect
    end

    def +(other)
      case other
      when Vector
        self.class.new(x: x + other.x, y: y + other.y)
      else
        raise TypeError
      end
    end

    def -(other)
      case other
      when Vector
        self.class.new(x: x - other.x, y: y - other.y)
      else
        raise TypeError
      end
    end

    def -@
      self.class.new(x: -x, y: -y)
    end

    def *(other)
      case other
      when Numeric
        self.class.new(x: x * other, y: y * other)
      else
        raise TypeError
      end
    end
  end
end
