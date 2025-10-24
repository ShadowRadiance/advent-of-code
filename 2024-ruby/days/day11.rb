# frozen_string_literal: true

module Days
  class Day11
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    class Solution
      attr_reader :stones

      def initialize(stones)
        @stones = stones
      end

      def blink(times)
        times.times do
          @stones.map! { |stone| blink_stone(stone) }
          @stones.flatten!
        end
      end

      def blink_stone(stone)
        return 1 if stone.zero?

        return split(stone) if stone.to_s.length.even?

        stone * 2024
      end

      def split(stone)
        half_length = stone.to_s.length / 2
        divisor = 10.pow(half_length)
        original_value = stone
        stone = original_value / divisor
        new_stone = original_value % divisor

        [
          stone,
          new_stone,
        ]
      end
    end

    def part_a
      solution = Solution.new(parse_input)
      solution.blink(25)
      solution.stones.size.to_s
      # 199982 instant
    end

    def part_b
      # should've seen this coming
      # too much array shuffling when we get this big
      solution = Solution.new(parse_input)
      solution.blink(75)
      solution.stones.size.to_s
      # too slow
    end

    def parse_input
      puzzle_input.split.map(&:to_i)
    end

    private

    attr_reader :puzzle_input
  end
end
