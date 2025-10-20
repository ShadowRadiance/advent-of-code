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

    class Calibration
      def initialize(total, operands, available_operators)
        @total = total
        @operands = operands
        @available_operators = available_operators
      end

      attr_reader :total, :operands, :available_operators

      def possible?
        possible_operations.any? do |operation|
          evaluate(operation) == total
        end
      end

      def possible_operations
        ops = available_operators.repeated_permutation(operands.length - 1)

        ops.map { |op_list| operands.zip(op_list).flatten.compact }.uniq
      end

      def evaluate(operation)
        value = operation.first
        idx = 1
        while idx < operation.length
          value = apply(value, operation[idx], operation[idx + 1])
          idx += 2
        end
        value
      end

      def apply(value, operator, operand)
        if operator.to_s == "||"
          "#{value}#{operand}".to_i
        else
          value.send(operator, operand)
        end
      end
    end

    class CalibrationWithCache < Calibration
      def initialize(total, operands, available_operators, global_cache = nil)
        super(total, operands, available_operators)
        @cache = global_cache || {}
      end

      attr_reader :cache

      def apply(value, operator, operand)
        key = [value, operator, operand]
        cached = cache[key]
        return cached unless cached.nil?

        cache[key] = super
      end
    end

    class Solver
      def initialize(input, operators = %i[+ *])
        cache = {}
        @calibrations = input.map do |hash|
          # Calibration.new(
          #   hash[:total],
          #   hash[:operands],
          #   operators,
          # )
          CalibrationWithCache.new(
            hash[:total],
            hash[:operands],
            operators,
            cache,
          )
        end
      end

      def total_calibration_result
        # sum of the test values from just the equations that could possibly be true
        @calibrations
          .filter(&:possible?)
          .map(&:total)
          .sum
      end
    end

    class ObjectlessSolver
      def initialize(parse_input, operators)
        # parse_input => [
        #   { total: 21_037, operands: [9, 7, 18, 13] },
        #   ...
        # ]
        @operators = operators # ["+", "*", "|"]
        @operator_permutations = {}
        @calibrations = parse_input
      end

      def operator_permutations(length)
        @operator_permutations[length] ||= @operators.repeated_permutation(length)
      end

      def total_calibration_result
        @calibrations.map { calibration_value(it) }.sum
      end

      def calibration_value(calibration)
        # calibration => { total: 21_037, operands: [9, 7, 18, 13] }
        calibration_total = calibration[:total]
        calibration_operands = calibration[:operands]

        operator_permutations(calibration_operands.length - 1).each do |operator_permutation|
          return calibration_total if evaluate(calibration_operands, operator_permutation) == calibration_total
        end

        0
      end

      def evaluate(operands, operators)
        value = operands.first

        (1...operands.length).each do |idx|
          value = apply(value, operators[idx - 1], operands[idx])
        end

        value
      end

      def apply(value, operator, operand)
        case operator
        when "+" then value + operand
        when "*" then value * operand
        when "|" then "#{value}#{operand}".to_i
        end
      end
    end

    # ---

    def part_a
      # Solver.new(parse_input).total_calibration_result.to_s
      # 7579994664753 in 28s (Calibration)
      # 7579994664753 in 29s (CalibrationWithCache) no help there
      ObjectlessSolver.new(parse_input, %w[+ *]).total_calibration_result.to_s
      # 7579994664753 instantaneously
    end

    def part_b
      # Solver.new(parse_input, %i[+ * ||]).total_calibration_result.to_s
      # 438027111276610 in 7m48s (Calibration)
      # 438027111276610 in 9m46s (CalibrationWithCache) no help there
      ObjectlessSolver.new(parse_input, %w[+ | *]).total_calibration_result.to_s
      # 438027111276610 in 24s
    end

    private

    attr_reader :puzzle_input
  end
end
