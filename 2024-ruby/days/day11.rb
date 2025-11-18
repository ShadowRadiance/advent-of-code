# frozen_string_literal: true

module Days
  class Day11
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    class Solution
      def initialize(stones)
        @stones = stones
      end

      def num_stones
        @stones.size
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

    class ListSolution
      def initialize(stones)
        @list = List.new(array: stones)
      end

      def blink(times) # rubocop:disable Metrics/MethodLength
        times.times do
          insertions = []
          @list.each do |node|
            value, new_value = blink_stone(node.value)
            node.value = value
            next unless new_value

            insertions << { after: node, value: new_value }
          end
          insertions.each do |insertion|
            @list.insert_after(insertion[:after], insertion[:value])
          end
        end
      end

      def blink_stone(stone)
        return [1] if stone.zero?

        return split(stone) if stone.to_s.length.even?

        [stone * 2024]
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

      def num_stones
        @list.size
      end
    end

    class List
      Node = Struct.new(:value, :prev, :succ, keyword_init: true) do
        def to_s
          value
        end
      end

      def initialize(array: nil)
        @head = nil
        return unless array

        array.reverse.each { |element| push_front(element) }
      end

      def push_front(value)
        node = Node.new(value: value, succ: @head)

        @head&.prev = node
        @head = node
      end

      def insert_after(node, value)
        new_node = Node.new(value: value, prev: node, succ: node.succ)

        node.succ&.prev = new_node
        node.succ = new_node
      end

      def each
        node = @head
        until node.nil?
          yield node
          node = node.succ
        end
      end

      def to_s
        str = +""
        each { str << "#{it.value} " }
        str
      end

      def size
        count = 0
        each { count += 1 }
        count
      end
    end

    class SolutionWJ
      def initialize(stones)
        @stones = Hash.new(0)
        stones.each { @stones[it] = 1 }
      end

      def blink_stone(stone)
        return [1] if stone.zero?

        stone_s = stone.to_s
        if stone.to_s.length.even?
          half = stone_s.length / 2
          return [
            stone_s[0...half].to_i,
            stone_s[half..].to_i,
          ]
        end

        [stone * 2024]
      end

      def blink_all
        new_stones = Hash.new(0)
        @stones.each do |stone, count|
          blink_stone(stone).each do |new_stone|
            new_stones[new_stone] += count
          end
        end
        @stones = new_stones
      end

      def blink(times)
        times.times do
          blink_all
        end
      end

      def num_stones
        @stones.values.sum
      end
    end

    def part_a
      # # solution = Solution.new(parse_input)
      # # solution.blink(25)
      # # solution.num_stones.to_s
      # # # 199982 instant
      # solution = ListSolution.new(parse_input)
      # solution.blink(25)
      # solution.num_stones.to_s
      # # 199982 instant
      solution = SolutionWJ.new(parse_input)
      solution.blink(25)
      solution.num_stones.to_s
      # 199982 instant
    end

    def part_b
      # should've seen this coming
      # too much array shuffling when we get this big
      # solution = Solution.new(parse_input)
      # solution.blink(75)
      # solution.num_stones.to_s
      # too slow after about 30 blinks
      # - maybe faster inserts with no array rewriting

      # it's list time
      # solution = ListSolution.new(parse_input)
      # solution.blink(75)
      # solution.num_stones.to_s

      # list solution STILL too slow after about 30 blinks
      # just too many to process individually...
      # do we have to look for a pattern for what happens
      # to classes of numbers?

      # Thanks to https://winslowjosiah.com/blog/2024/12/11/advent-of-code-2024-day-11/
      # for pointing out that:
      #   the stones don't affect each other
      #   each stone can be handled on its own
      # so we can store a hash of stone-number => count
      # each "blink" we iterate of the existing hash and create a new
      # one by doing each "stone-number" once, but adding count to the new-count
      # Example: "24 6 6"
      # INITIAL: {24=>1 6=>2}
      #          24 becomes 2 and 4 (*1 each)
      #           6 becomes 12144 (*1)
      # ITERATE: {2=>1, 4=>1, 12144=>2}
      #           2 becomes 4048 (*1)
      #           4 becomes 8096 (*1)
      #       12144 becomes 24579456 (*2)
      # ITERATE: {4048=>1, 8096=>1, 24579456=>2}
      #        4048 becomes 40 and 48 (*1)
      #        8096 becomes 80 and 96 (*1)
      #    24579456 becomes 2457 and 9456 (*2)
      # ITERATE: {40=>1, 48=>1, 80=>1, 96=>1, 2457=>2, 9456=>2}
      # etc...

      solution = SolutionWJ.new(parse_input)
      solution.blink(75)
      solution.num_stones.to_s
      # 237149922829154 instant
    end

    def parse_input
      puzzle_input.split.map(&:to_i)
    end

    private

    attr_reader :puzzle_input
  end
end
