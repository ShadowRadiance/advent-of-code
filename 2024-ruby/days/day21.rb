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
      # Not great - implies we're missing something
    end

    def part_b
      # Trying to use the existing solver as is with more bots
      # does not complete
      # Solver.new(@puzzle_input, number_of_controller_pad_bots: 25)
      #       .sum_of_code_complexities
      #       .to_s
      0
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
          "A" => [
            "A", # A to A
          ],
          "0" => [
            "<A", # A to 0
          ],
          "1" => [
            "^<<A", "<^<A", # A to 2 to 1
          ],
          "2" => [
            "^<A", # A to 0 to 2
            "<^A", # A to 3 to 2
          ],
          "3" => [
            "^A", # A to 3
          ],
          "4" => [
            "^^<<A",                            # A to 5 to 4
            "^<<^A", "^<^<A", "<^<^A", "<^^<A", # A to 1 to 4
          ],
          "5" => [
            "^^<A",         # 6 to 5
            "^<^A", "<^^A", # 2 to 5
          ],
          "6" => [
            "^^A", # A to 3 to 6
          ],
          "7" => [
            "^^^<<A", "^^<^<A", "^<^^<A", "<^^^<A",           # A to 8 to 7
            "^^<<^A", "^<<^^A", "^<^<^A", "<^<^^A", "<^^<^A", # A to 4 to 7
          ],
          "8" => [
            "^^^<A",                   # A to 9 to 8
            "^^<^A", "^<^^A", "<^^^A", # A to 5 to 8
          ],
          "9" => [
            "^^^A", # A to 6 to 9
          ],
        },
        "0" => {
          "A" => [">A"],
          "0" => ["A"],
          "1" => ["^<A"],
          "2" => ["^A"],
          "3" => [
            "^>A", # 0 to 2 to 3
            ">^A", # 0 to A to 3
          ],
          "4" => [
            "^^<A", # 0 to 5 to 4
            "^<^A", # 0 to 1 to 4
          ],
          "5" => ["^^A"],
          "6" => [
            "^^>A",         # 0 to 5 to 6
            "^>^A", ">^^A", # 0 to 3 to 6
          ],
          "7" => [
            "^^^<A",          # 0 to 8 to 7
            "^^<^A", "^<^^A", # 0 to 4 to 7
          ],
          "8" => ["^^^A"],
          "9" => [
            "^^^>A",                   # 0 to 8 to 9
            "^^>^A", "^>^^A", ">^^^A", # 0 to 6 to 9
          ],
        },
        "1" => {
          "A" => [
            ">v>A", # 1 to 0 to A
            ">>vA", # 1 to 3 to A
          ],
          "0" => [">vA"],
          "1" => ["A"],
          "2" => [">A"],
          "3" => [">>A"],
          "4" => ["^A"],
          "5" => [
            ">^A", # 1 to 2 to 5
            "^>A", # 1 to 4 to 5
          ],
          "6" => [
            ">^>A", "^>>A", # 1 to 5 to 6
            ">>^A",         # 1 to 3 to 6
          ],
          "7" => ["^^A"],
          "8" => [
            "^^>A",         # 1 to 7 to 8
            ">^^A", "^>^A", # 1 to 5 to 8
          ],
          "9" => [
            "^^>>A", ">^^>A", "^>^>A", # 1 to 8 to 9
            ">^>^A", "^>>^A", ">>^^A", # 1 to 6 to 9
          ],
        },
        "2" => {
          "A" => [">vA", "v>A"],
          "0" => ["vA"],
          "1" => ["<A"],
          "2" => ["A"],
          "3" => [">A"],
          "4" => ["^<A", "<^A"],
          "5" => ["^A"],
          "6" => ["^>A", ">^A"],
          "7" => ["^<^A", "<^^A", "^^<A"],
          "8" => ["^^A"],
          "9" => ["^>^A", ">^^A", "^^>A"],
        },
        "3" => {
          "A" => ["vA"],
          "0" => ["v<A", "<vA"],
          "1" => ["<<A"],
          "2" => ["<A"],
          "3" => ["A"],
          "4" => ["<<^A", "^<<A", "<^<A"],
          "5" => ["^<A", "<^A"],
          "6" => ["^A"],
          "7" => ["^<^<A", "<^^<A", "^^<<A", "<<^^A", "^<<^A", "<^<^A"],
          "8" => ["^<^A", "<^^A", "^^<A"],
          "9" => ["^^A"],
        },
        "4" => {
          "A" => [">vv>A", "v>v>A", ">v>vA", "v>>vA", ">>vvA"],
          "0" => [">vvA", "v>vA"],
          "1" => ["vA"],
          "2" => [">vA", "v>A"],
          "3" => [">v>A", "v>>A", ">>vA"],
          "4" => ["A"],
          "5" => [">A"],
          "6" => [">>A"],
          "7" => ["^A"],
          "8" => [">^A", "^>A"],
          "9" => [">^>A", "^>>A", ">>^A"],
        },
        "5" => {
          "A" => ["vv>A", "v>vA", ">vvA"],
          "0" => ["vvA"],
          "1" => ["v<A", "<vA"],
          "2" => ["vA"],
          "3" => ["v>A", ">vA"],
          "4" => ["<A"],
          "5" => ["A"],
          "6" => [">A"],
          "7" => ["^<A", "<^A"],
          "8" => ["^A"],
          "9" => ["^>A", ">^A"],
        },
        "6" => {
          "A" => ["vvA"],
          "0" => ["vv<A", "<vvA", "v<vA"],
          "1" => ["<<vA", "<v<A", "v<<A"],
          "2" => ["<vA", "v<A"],
          "3" => ["vA"],
          "4" => ["<<A"],
          "5" => ["<A"],
          "6" => ["A"],
          "7" => ["<<^A", "^<<A", "<^<A"],
          "8" => ["^<A", "<^A"],
          "9" => ["^A"],
        },
        "7" => {
          "A" => [
            "vv>v>A", "v>vv>A", ">vvv>A",                               # 7 to 0 to A
            "vv>>vA", "v>v>vA", ">vv>vA", "v>>vvA", ">v>vvA", ">>vvvA", # 7 to 3 to A
          ],
          "0" => ["vv>vA", "v>vvA", ">vvvA"],
          "1" => ["vvA"],
          "2" => ["vv>A", "v>vA", ">vvA"],
          "3" => [
            "vv>>A", "v>v>A", ">vv>A", # 7 to 2 to 3
            "v>>vA", ">v>vA", ">>vvA", # 7 to 6 to 3
          ],
          "4" => ["vA"],
          "5" => ["v>A", ">vA"],
          "6" => ["v>>A", ">v>A", ">>vA"],
          "7" => ["A"],
          "8" => [">A"],
          "9" => [">>A"],
        },
        "8" => {
          "A" => ["vvv>A", "v>vvA", ">vvvA", "vv>vA"],
          "0" => ["vvvA"],
          "1" => ["v<vA", "<vvA", "vv<A"],
          "2" => ["vvA"],
          "3" => ["v>vA", ">vvA", "vv>A"],
          "4" => ["v<A", "<vA"],
          "5" => ["vA"],
          "6" => ["v>A", ">vA"],
          "7" => ["<A"],
          "8" => ["A"],
          "9" => [">A"],
        },
        "9" => {
          "A" => ["vvvA"],
          "0" => ["vvv<A", "v<vvA", "<vvvA", "vv<vA"],
          "1" => [
            "v<v<A", "<vv<A", "vv<<A",
            "<<vvA", "v<<vA", "<v<vA",
          ],
          "2" => ["v<vA", "<vvA", "vv<A"],
          "3" => ["vvA"],
          "4" => ["<<vA", "v<<A", "<v<A"],
          "5" => ["v<A", "<vA"],
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
          "<" => ["v<<A", "<v<A"],
          "v" => ["v<A", "<vA"],
          ">" => ["vA"],
        },
        "^" => {
          "^" => ["A"],
          "A" => [">A"],
          "<" => ["v<A"],
          "v" => ["vA"],
          ">" => ["v>A", ">vA"],
        },
        "<" => {
          "^" => [">^A"],
          "A" => [">>^A", ">^>A"],
          "<" => ["A"],
          "v" => [">A"],
          ">" => [">>A"],
        },
        "v" => {
          "^" => ["^A"],
          "A" => [">^A", "^>A"],
          "<" => ["<A"],
          "v" => ["A"],
          ">" => [">A"],
        },
        ">" => {
          "^" => ["^<A", "<^A"],
          "A" => ["^A"],
          "<" => ["<<A"],
          "v" => ["<A"],
          ">" => ["A"],
        },
      }.freeze
    end
  end
end
