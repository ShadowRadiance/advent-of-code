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
      # 156714 in 0.05s after adding cache
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
      # caching per "command step"
      # 191139369248202 after 0.05s
    end

    class Solver # rubocop:disable Metrics/ClassLength
      def initialize(puzzle_input, number_of_controller_pad_bots: 2)
        @codes = puzzle_input.lines(chomp: true)
        @number_of_controller_pad_bots = number_of_controller_pad_bots

        @number_pad_bot = Robot.new(NUMBER_PAD_ROBOT_INSTRUCTIONS)
        @controller_bot = Robot.new(CONTROLLER_PAD_ROBOT_INSTRUCTIONS)

        # @type [Hash<String,Array<Integer>>] @cache
        @cache = {}
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

      # Inspired by bytesizego
      # https://www.bytesizego.com/blog/aoc-day21-golang
      def count_after_n_robots(code, max_bots, curr_bot) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        @cache[code] ||= Array.new(@number_of_controller_pad_bots, 0)
        cache_for_code = @cache[code]

        return @cache[code][curr_bot - 1] if cache_for_code[curr_bot - 1] != 0

        next_code = @controller_bot.only_translation(code)
        cache_for_code[0] = next_code.length
        return next_code.length if curr_bot == max_bots

        count = 0
        steps(next_code).each do |step_code|
          c = count_after_n_robots(step_code, max_bots, curr_bot + 1)
          @cache[step_code] ||= Array.new(@number_of_controller_pad_bots, 0)
          @cache[step_code][0] = c
          count += c
        end
        cache_for_code[curr_bot - 1] = count

        count
      end

      # split code string into substrings ending at each "A"
      def steps(code)
        regex = /([^A]*A)/
        output = []
        m = regex.match(code, 0)
        until m.nil?
          output << m[1]
          m = regex.match(code, m.end(1))
        end
        output
      end

      def shortest_path_length(code)
        initial = @number_pad_bot.only_translation(code)
        count_after_n_robots(initial, @number_of_controller_pad_bots, 1)
      end

      class Robot
        def initialize(instruction_set)
          @instruction_set = instruction_set
        end

        def instructions(from:, to:)
          @instruction_set[from][to]
        end

        def only_translation(code)
          result = +""
          code.chars.each_with_index do |char, index|
            result << instructions(
              from: index.zero? ? "A" : code[index - 1],
              to: char,
            ).first
          end
          result
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
