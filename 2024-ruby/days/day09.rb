# frozen_string_literal: true

require "forwardable"

module Days
  class Day09
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    class StrategyBase
      def initialize(disk_map)
        @disk_map = disk_map
      end
    end

    class StrategyBlocksBase < StrategyBase
      extend Forwardable

      def_delegator :@disk_map, :blocks
    end

    class MoveFileBlocks < StrategyBlocksBase
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

    class MoveWholeFiles < StrategyBlocksBase
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

    class MoveFileBlocksSmarter < StrategyBlocksBase
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

    File = Struct.new(:index, :size, :id, keyword_init: true) do # rubocop:disable Lint/StructNewOverride
      def inspect
        "ID#{id}(#{index},#{size})"
      end

      def to_s
        inspect
      end
    end

    Free = Struct.new(:index, :size, keyword_init: true) do # rubocop:disable Lint/StructNewOverride
      def inspect
        "F(#{index},#{size})"
      end
    end

    class MoveWholeFilesSmarter < StrategyBase
      def initialize(disk_map)
        super

        @file_list = []
        @free_list = {}

        build_lists
      end

      def compact
        # representation: 2333133121414131402
        # blocks-initial: 00...111...2...333.44.5555.6666.777.888899
        # blocks-desired: 00992111777.44.333....5555.6666.....8888..

        # keep list of files, ordered by id
        # keep list of free spaces (bucketed by size), ordered by lowest index
        # so when looking for the earliest place to put a file of size N
        #   we look in FreeList[N][0], then in FreeList[N+1], etc
        #   remembering we can't move files later, only earlier
        # when we move a File,
        #   the Free we move into will shrink (and move lists)
        #   the Frees directly before and after the old File location will combine (and move lists)
        # building the FreeList and FileList requires the puzzle input instead of the blocks
        @file_list.reverse.each do |file|
          free = find_free(file.size, before: file.index)
          next unless free

          move(file, to: free)
          build_blocks_for_checksum
        end
      end

      def build_blocks_for_checksum
        @disk_map.blocks.each_index { |idx| @disk_map.blocks[idx] = "." }
        @file_list.each do |file|
          file.size.times do |idx|
            @disk_map.blocks[file.index + idx] = file.id
          end
        end
      end

      def move(file, to:)
        file.index = to.index

        @free_list[to.size].delete(to)

        to.index = to.index + file.size
        to.size -= file.size

        @free_list[to.size] << to
        @free_list[to.size].sort_by!(&:index)
      end

      def find_free(length, before:) # rubocop:disable Metrics/CyclomaticComplexity
        return nil if @free_list.keys.max < length

        best_free = nil

        (length..@free_list.keys.max).each do |n|
          free = @free_list[n]&.first
          next if free.nil?
          next if free.index >= before

          best_free = free if best_free.nil? || free.index < best_free.index
        end

        best_free
      end

      def build_lists # rubocop:disable Metrics/MethodLength
        next_is_space = false
        idx = 0
        file_id = 0
        @disk_map.representation.chars.each do |char|
          num = char.to_i
          if next_is_space
            @free_list[num] ||= []
            @free_list[num] << Free.new(index: idx, size: num)
          else
            @file_list << File.new(index: idx, size: num, id: file_id)
            file_id += 1
          end
          idx += num
          next_is_space = !next_is_space
        end

        build_blocks_for_checksum
      end
    end

    class DiskMap
      def initialize(representation, strategy: MoveFileBlocks)
        @representation = representation
        @blocks = []
        @strategy = strategy
        parse_blocks
      end

      attr_reader :blocks, :representation

      def checksum
        blocks.map.with_index { |char, idx| evaluate(char, idx) }.sum
      end

      def compact
        @strategy.new(self).compact

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
      # 6346871685398 instantaneous!!
    end

    def part_b
      # DiskMap.new(puzzle_input, strategy: MoveWholeFiles)
      #        .compact
      #        .checksum.to_s
      # 6373055193464 in 2m57s YIKES!
      DiskMap.new(puzzle_input, strategy: MoveWholeFilesSmarter)
             .compact
             .checksum.to_s
      # 6350673328412 (22381865052 too low) in 37s
      # 6373055193464 in 37s
    end

    private

    attr_reader :puzzle_input
  end
end
