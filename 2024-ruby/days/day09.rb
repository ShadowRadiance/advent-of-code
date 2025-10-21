# frozen_string_literal: true

module Days
  class Day09
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    class DiskMap
      def initialize(blocks)
        @blocks = blocks
      end

      attr_reader :blocks

      def checksum
        @blocks.map.with_index { |char, idx| evaluate(char, idx) }.sum
      end

      def compact
        space_blocks_count = blocks.count { it == "." }
        correct_first_space_index = blocks.length - space_blocks_count

        loop do
          first_space_index = blocks.index(".")
          break if first_space_index == correct_first_space_index

          last_digit_index = blocks.rindex { it != "." }

          # swap
          blocks[first_space_index] = blocks[last_digit_index]
          blocks[last_digit_index] = "."
        end

        self
      end

      private

      def evaluate(char, idx)
        return 0 if char == "."

        char.to_i * idx
      end

      class << self
        def from_representation(rep)
          new(parse_blocks(rep))
        end

        def parse_blocks(rep)
          blocks = []
          "#{rep}0".chars.each_slice(2).with_index do |(file_size, space_size), file_id|
            file_size.to_i.times { blocks << file_id }
            space_size.to_i.times { blocks << "." }
          end
          blocks
        end
      end
    end

    def part_a
      DiskMap.from_representation(puzzle_input)
             .compact
             .checksum.to_s
      # 6346871685398 in 1m39s YIKES!
    end

    def part_b
      "PENDING_B"
    end

    private

    attr_reader :puzzle_input
  end
end
