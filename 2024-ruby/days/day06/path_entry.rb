# frozen_string_literal: true

module Days
  class Day06
    PathEntry = Data.define(:location, :direction) do
      def inspect
        "<#{location.x},#{location.y},#{direction.to_c}>"
      end
    end
  end
end
