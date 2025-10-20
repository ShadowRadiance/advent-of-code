# frozen_string_literal: true

Vector = Data.define(:x, :y) do
  def inspect
    "V(#{x},#{y})"
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

  def *(other)
    case other
    when Numeric
      self.class.new(x: x * other, y: y * other)
    else
      raise TypeError
    end
  end
end
