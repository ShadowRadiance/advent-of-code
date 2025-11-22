# frozen_string_literal: true

module Days
  class Day21
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def part_a
      Solver.new(@puzzle_input, number_of_controller_pad_bots: 2)
            .sum_of_code_complexities
            .to_s
      # 156714 in 5s
      # 156714 in 0.5s after removing moves that cost more next time
    end

    def part_b
      # Trying to use the existing solver as is with more bots
      # does not complete
      # Solver.new(@puzzle_input, number_of_controller_pad_bots: 25)
      #       .sum_of_code_complexities
      #       .to_s
      Solver.new(@puzzle_input, number_of_controller_pad_bots: 25)
            .sum_of_code_complexities
            .to_s
      # Fewer turns preference - still DNC
      # LUDR preference - still DNC
    end

    class Solver
      def initialize(puzzle_input, number_of_controller_pad_bots: 2)
        @codes = puzzle_input.lines(chomp: true)

        butn_bot = Robot.new(NUMBER_PAD_ROBOT_INSTRUCTIONS)
        controller_pad_bots = Array.new(number_of_controller_pad_bots) do
          Robot.new(CONTROLLER_PAD_ROBOT_INSTRUCTIONS)
        end
        @bots = [butn_bot] + controller_pad_bots
      end

      def sum_of_code_complexities
        @codes.map { |code| complexity(code) }.sum
      end

      def complexity(code)
        numeric(code) * shortest_path_length(code)
      end

      def numeric(code)
        code.gsub(/^0+/, "").gsub(/A$/, "").to_i
      end

      def shortest_path_length(code)
        codes = [code]
        @bots.each do |bot|
          codes = codes.flat_map { |code| bot.all_translations(code) }
          shortest = codes.min_by(&:length).length
          codes = codes.reject { |t| t.length > shortest }
        end
        codes&.at(0)&.length
      end

      class Robot
        def initialize(instruction_set)
          @instruction_set = instruction_set
        end

        def instructions(from:, to:)
          @instruction_set[from][to]
        end

        # @param [String] code
        # @return [Array<String>] possible translations
        def all_translations(code)
          translations = [""]
          code.chars.each_with_index do |char, index|
            replacements = instructions(
              from: index.zero? ? "A" : code[index - 1],
              to: char,
            )

            translations = translations.flat_map do |t|
              replacements.map do |r|
                t + r
              end
            end
          end

          # shortest = translations.min_by(&:length).length
          # translations.reject { |t| t.length > shortest }
          translations
        end
      end

      NUMBER_PAD_ROBOT_INSTRUCTIONS = {
        "A" => {
          "A" => ["A"],
          "0" => ["<A"],
          "1" => ["^<<A"],
          "2" => ["<^A"],
          "3" => ["^A"],
          "4" => ["^^<<A"],
          "5" => ["<^^A"],
          "6" => ["^^A"],
          "7" => ["^^^<<A"],
          "8" => ["<^^^A"],
          "9" => ["^^^A"],
        },
        "0" => {
          "A" => [">A"],
          "0" => ["A"],
          "1" => ["^<A"],
          "2" => ["^A"],
          "3" => ["^>A"],
          "4" => ["^^<A"],
          "5" => ["^^A"],
          "6" => ["^^>A"],
          "7" => ["^^^<A"],
          "8" => ["^^^A"],
          "9" => ["^^^>A"],
        },
        "1" => {
          "A" => [">>vA"],
          "0" => [">vA"],
          "1" => ["A"],
          "2" => [">A"],
          "3" => [">>A"],
          "4" => ["^A"],
          "5" => ["^>A"],
          "6" => ["^>>A"],
          "7" => ["^^A"],
          "8" => ["^^>A"],
          "9" => ["^^>>A"],
        },
        "2" => {
          "A" => ["v>A"],
          "0" => ["vA"],
          "1" => ["<A"],
          "2" => ["A"],
          "3" => [">A"],
          "4" => ["^<A"],
          "5" => ["^A"],
          "6" => ["^>A"],
          "7" => ["<^^A"],
          "8" => ["^^A"],
          "9" => ["^^>A"],
        },
        "3" => {
          "A" => ["vA"],
          "0" => ["<vA"],
          "1" => ["<<A"],
          "2" => ["<A"],
          "3" => ["A"],
          "4" => ["<<^A"],
          "5" => ["<^A"],
          "6" => ["^A"],
          "7" => ["<<^^A"],
          "8" => ["<^^A"],
          "9" => ["^^A"],
        },
        "4" => {
          "A" => [">>vvA"],
          "0" => [">vvA"],
          "1" => ["vA"],
          "2" => ["v>A"],
          "3" => ["v>>A"],
          "4" => ["A"],
          "5" => [">A"],
          "6" => [">>A"],
          "7" => ["^A"],
          "8" => ["^>A"],
          "9" => ["^>>A"],
        },
        "5" => {
          "A" => ["vv>A"],
          "0" => ["vvA"],
          "1" => ["<vA"],
          "2" => ["vA"],
          "3" => ["v>A"],
          "4" => ["<A"],
          "5" => ["A"],
          "6" => [">A"],
          "7" => ["<^A"],
          "8" => ["^A"],
          "9" => ["^>A"],
        },
        "6" => {
          "A" => ["vvA"],
          "0" => ["<vvA"],
          "1" => ["<<vA"],
          "2" => ["<vA"],
          "3" => ["vA"],
          "4" => ["<<A"],
          "5" => ["<A"],
          "6" => ["A"],
          "7" => ["<<^A"],
          "8" => ["<^A"],
          "9" => ["^A"],
        },
        "7" => {
          "A" => [">>vvvA"],
          "0" => [">vvvA"],
          "1" => ["vvA"],
          "2" => ["vv>A"],
          "3" => ["vv>>A"],
          "4" => ["vA"],
          "5" => ["v>A"],
          "6" => ["v>>A"],
          "7" => ["A"],
          "8" => [">A"],
          "9" => [">>A"],
        },
        "8" => {
          "A" => ["vvv>A"],
          "0" => ["vvvA"],
          "1" => ["<vvA"],
          "2" => ["vvA"],
          "3" => ["vv>A"],
          "4" => ["<vA"],
          "5" => ["vA"],
          "6" => ["v>A"],
          "7" => ["<A"],
          "8" => ["A"],
          "9" => [">A"],
        },
        "9" => {
          "A" => ["vvvA"],
          "0" => ["<vvvA"],
          "1" => ["<<vvA"],
          "2" => ["<vvA"],
          "3" => ["vvA"],
          "4" => ["<<vA"],
          "5" => ["<vA"],
          "6" => ["vA"],
          "7" => ["<<A"],
          "8" => ["<A"],
          "9" => ["A"],
        },
      }.freeze

      CONTROLLER_PAD_ROBOT_INSTRUCTIONS = {
        "A" => {
          "^" => ["<A"],
          "A" => ["A"],
          "<" => ["v<<A"],
          "v" => ["<vA"],
          ">" => ["vA"],
        },
        "^" => {
          "^" => ["A"],
          "A" => [">A"],
          "<" => ["v<A"],
          "v" => ["vA"],
          ">" => ["v>A"],
        },
        "<" => {
          "^" => [">^A"],
          "A" => [">>^A"],
          "<" => ["A"],
          "v" => [">A"],
          ">" => [">>A"],
        },
        "v" => {
          "^" => ["^A"],
          "A" => ["^>A"],
          "<" => ["<A"],
          "v" => ["A"],
          ">" => [">A"],
        },
        ">" => {
          "^" => ["<^A"],
          "A" => ["^A"],
          "<" => ["<<A"],
          "v" => ["<A"],
          ">" => ["A"],
        },
      }.freeze
    end
  end
end

# LUDR preference:
#   it really matters if we can arrange the sequence to
#   press the more expensive keys multiple times in a row!
#   If you're going to be pressing <, you always want to
#   press it multiple times in a row (^^<<< is MUCH cheaper
#   on a nested keypad than <^<^<, because the parent keypad
#   has to go press A to confirm each step and < is so far
#   away from A!)
# IN GENERAL:
#   since we have to return to A, the furthest keys should be
#   pressed first
