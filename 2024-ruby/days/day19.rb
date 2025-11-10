# frozen_string_literal: true

module Days
  class Day19
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    Input = Data.define(:available_patterns, :desired_designs)
    def parse_input
      towels, designs = @puzzle_input.split("\n\n")
      Input.new(towels.split(", "), designs.lines(chomp: true))
    end

    def part_a
      solver = Solver.new(parse_input)
      solver.possible_design_count
            .to_s
    end

    def part_b
      "PENDING_B"
    end

    class Solver
      def initialize(input)
        @available_patterns = Set.new(input.available_patterns)
        @desired_designs = input.desired_designs
      end

      def possible_design_count
        possible_designs.count
      end

      def possible_designs
        @desired_designs.filter { possible?(it) }
      end

      def possible?(design)
        # can you create design (e.g. brwrr, bbrgwb) using a combination of patterns (r wr b g bwu rb gb br)?
        return true if design.empty?

        @available_patterns.each do |pattern|
          next unless design.start_with?(pattern)
          return true if possible?(design[pattern.size..])
        end

        false
      end
    end
  end
end
