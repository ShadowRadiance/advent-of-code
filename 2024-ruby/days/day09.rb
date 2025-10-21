# frozen_string_literal: true

module Days
  class Day09
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    class StrategyBase
      def initialize(blocks)
        @blocks = blocks
      end

      attr_reader :blocks
    end

    class MoveFileBlocks < StrategyBase
      def compact
        space_blocks_count = blocks.count { it == "." }
        correct_first_space_index = blocks.length - space_blocks_count

        loop do
          # constantly scanning through the blocks *from the start* each time
          # through the loops is inefficient
          first_space_index = blocks.index(".")
          break if first_space_index == correct_first_space_index

          last_digit_index = blocks.rindex { it != "." }

          # swap
          blocks[first_space_index] = blocks[last_digit_index]
          blocks[last_digit_index] = "."
        end
      end
    end

    class MoveWholeFiles < StrategyBase
      def compact
        last_file_block = blocks.rindex { it != "." }       # scan
        last_file_id = blocks[last_file_block].to_i
        last_file_id.downto(0) do |file_id|
          try_move_file(file_id)
        end
      end

      def try_move_file(file_id)
        start_of_file = blocks.index(file_id)               # scan
        end_of_file = blocks.rindex(file_id)                # scan

        return if start_of_file.nil?

        file_size = end_of_file - start_of_file + 1
        target = find_space(file_size, before: start_of_file)
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

    class MoveFileBlocksSmarter < StrategyBase
      def compact # rubocop:disable Metrics/MethodLength
        left = 0
        right = blocks.length - 1
        while left < right
          if blocks[left] == "." && blocks[right] != "."
            blocks[left], blocks[right] = blocks[right], blocks[left]
            left += 1
            right -= 1
            next
          end
          left += 1 if blocks[left] != "."
          right -= 1 if blocks[right] == "."
        end
      end
    end

    File = Data.define(:index, :size, :id)
    Free = Data.define(:index, :size)
    class MoveWholeFilesSmarter < StrategyBase
      def compact
        # keep list of files, ordered by id
        # keep list of free spaces (bucketed by size), ordered by lowest index
        # so when looking for the earliest place to put a file of size N
        #   we look in FreeList[N][0], then in FreeList[N+1], etc
        #   remembering we can't move files later, only earlier
        # when we move a File,
        #   the Free we move into will shrink (and move lists)
        #   the Frees directly before and after the old File location will combine (and move lists)
        # building the FreeList and FileList requires the puzzle input instead of the blocks
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
      # DiskMap.new(puzzle_input, strategy: MoveFileBlocks)
      #        .compact
      #        .checksum.to_s
      # 6346871685398 in 1m39s YIKES!
      DiskMap.new(puzzle_input, strategy: MoveFileBlocksSmarter)
             .compact
             .checksum.to_s
      # 6346871685398 instantaneous
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
