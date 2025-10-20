# frozen_string_literal: true

module Days
  class Day07
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def parse_input
      puzzle_input.lines(chomp: true).map do |line|
        parse_line(line)
      end
    end

    def parse_line(line)
      total_str, rest_str = line.split(": ")

      total = total_str.to_i
      operands = rest_str.split.map(&:to_i)

      {
        total: total,
        operands: operands,
      }
    end

    Calibration = Data.define(:total, :operands) do
      def possible?
        possible_operations.any? do |operation|
          evaluate(operation) == total
        end
      end

      def available_operators
        %i[+ *]
      end

      def possible_operations
        ops = available_operators.product
        (operands.length - 2).times do
          ops = ops.product(available_operators).map(&:flatten)
        end

        ops.map { |op_list| operands.zip(op_list).flatten.compact }
      end

      def evaluate(operation)
        value = operation.first
        idx = 1
        while idx < operation.length
          value = value.send(operation[idx], operation[idx + 1])
          idx += 2
        end
        value
      end
    end

    class Solver
      def initialize(input)
        @calibrations = input.map { |hash| Calibration.new(**hash) }
      end

      def total_calibration_result
        # sum of the test values from just the equations that could possibly be true
        @calibrations
          .filter(&:possible?)
          .map(&:total)
          .sum
      end
    end

    # ---

    def part_a
#       Solver.new(parse_input).total_calibration_result.to_s
      # 7579994664753 in 28s
    end

    def part_b
      "PENDING-B"
    end

    private

    attr_reader :puzzle_input
  end
end
