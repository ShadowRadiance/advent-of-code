# frozen_string_literal: true

module Days
  class Day06
    class Guard
      attr_reader :location, :direction

      def initialize(location, direction)
        @location = location
        @direction = direction
      end

      def turn_right
        @direction = @direction.rotate90right
      end

      def move_forward
        @location += @direction
      end
    end
  end
end
