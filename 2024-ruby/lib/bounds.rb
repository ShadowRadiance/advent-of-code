# frozen_string_literal: true

Bounds = Data.define(:min_x, :min_y, :max_x, :max_y) do
  def inspect
    "B(#{min_x},#{min_y}\\#{max_x},#{max_y})"
  end

  def to_s
    inspect
  end

  def cover?(x:, y:) # rubocop:disable Naming/MethodParameterName
    return false if x < min_x
    return false if x > max_x
    return false if y < min_y
    return false if y > max_y

    true
  end
end
