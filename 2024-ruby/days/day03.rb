# frozen_string_literal: true

module Days
  class Day03
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    RX_GOOD_MUL = /mul\(\d+,\d+\)/
    MUL_VALUES = /mul\((\d+),(\d+)\)/
    RX_GOOD_MUL_WITH_TOGGLES = /
      (
        mul\(\d+,\d+\)
      )|(
        do\(\)
      )|(
        don't\(\)
      )
    /x

    def part_a
      puzzle_input.scan(RX_GOOD_MUL)
                  .map { |mul| perform_mul(mul) }
                  .sum
                  .to_s
    end

    def part_b
      instructions = puzzle_input.scan(RX_GOOD_MUL_WITH_TOGGLES)
                                 .map { |e| e.compact.first }
      # scan ==> [["mul(2,4)", nil, nil],
      #           [nil, nil, "don't()"],
      #           ["mul(5,5)", nil, nil],
      #           ["mul(11,8)", nil, nil],
      #           [nil, "do()", nil],
      #           ["mul(8,5)", nil, nil]]
      # map  ==> ["mul(2,4)",
      #           "don't()",
      #            "mul(5,5)",
      #            "mul(11,8)",
      #            "do()",
      #            "mul(8,5)"]

      # start in DO mode
      # iterate over result
      # DO switches to DO mode
      # DONT switches to DONT mode
      # MUL ignored in DONT mode
      # MUL applied in DO mode

      filter_instructions(instructions)
        .map { |mul| perform_mul(mul) }
        .sum
        .to_s
    end

    def filter_instructions(instructions) # rubocop:disable Metrics/MethodLength
      do_mode = true
      instructions.filter do |instruction|
        case instruction
        when "don't()"
          do_mode = false
          nil
        when "do()"
          do_mode = true
          nil
        else
          instruction if do_mode
        end
      end
    end

    def parse_input
      puzzle_input
    end

    def perform_mul(mul)
      mul.scan(MUL_VALUES)
         .first
         .map(&:to_i)
         .reduce(:*)
    end

    private

    attr_reader :puzzle_input
  end
end
