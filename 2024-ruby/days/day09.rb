# frozen_string_literal: true

module Days
  class Day09
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    class MoveFileBlocks
      attr_reader :blocks

      def initialize(blocks)
        @blocks = blocks
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
      end
    end

    class MoveWholeFiles
      attr_reader :blocks

      def initialize(blocks)
        @blocks = blocks
      end

      def compact
        last_file_block = blocks.rindex { it != "." }
        last_file_id = blocks[last_file_block].to_i
        last_file_id.downto(0) do |file_id|
          try_move_file(file_id)
        end
      end

      def try_move_file(file_id)
        start_of_file = blocks.index(file_id)
        end_of_file = blocks.rindex(file_id)

        return if start_of_file.nil?

        file_size = end_of_file - start_of_file + 1
        target = find_space(file_size, before: start_of_file)

        movable = target || "NOMOVE"
        puts "#{file_id}: [#{start_of_file}+#{file_size}] -->#{movable}"

        return if target.nil?

        move_file(file_id, start_of_file, file_size, target)
      end

      def move_file(file_id, start_of_file, file_size, target)
        file_size.times do |offset|
          blocks[target + offset] = file_id
          blocks[start_of_file + offset] = "."
        end
      end

      def find_space(spaces, before:)
        idx = 0
        loop do
          return nil if idx >= before
          return idx if idx_valid?(idx, spaces)

          idx += 1
        end
      end

      def idx_valid?(idx, spaces)
        (0...spaces).all? { |spc_idx| blocks[idx + spc_idx] == "." }
      end
    end

    class DiskMap
      def initialize(representation, strategy: MoveFileBlocks)
        @representation = representation
        @blocks = []
        parse_blocks
        @strategy = strategy
      end

      attr_reader :blocks

      def checksum
        @blocks.map.with_index { |char, idx| evaluate(char, idx) }.sum
      end

      def compact
        strategy = @strategy.new(@blocks)
        strategy.compact
        @blocks = strategy.blocks

        self
      end

      private

      def evaluate(char, idx)
        return 0 if char == "."

        char.to_i * idx
      end

      def parse_blocks
        "#{@representation}0".chars.each_slice(2).with_index do |(file_size, space_size), file_id|
          file_size.to_i.times { blocks << file_id }
          space_size.to_i.times { blocks << "." }
        end
      end
    end

    def part_a
      DiskMap.new(puzzle_input)
             .compact
             .checksum.to_s
      # 6346871685398 in 1m39s YIKES!
    end

    def part_b
      DiskMap.new(puzzle_input, strategy: MoveWholeFiles)
             .compact
             .checksum.to_s
      # 6373055193464 in 2m57s YIKES!
    end

    private

    attr_reader :puzzle_input
  end
end
