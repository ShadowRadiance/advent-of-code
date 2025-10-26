# frozen_string_literal: true

require "matrix"

require_relative "../lib/aoc/direction"
require_relative "../lib/aoc/location"

module Days
  class Day13
    class MachineBuilder
      BUTTON_REGEX = /Button (?:A|B): X\+(\d+), Y\+(\d+)/
      PRIZE_REGEX = /Prize: X=(\d+), Y=(\d+)/

      def build_machine_from_description(button_a_desc, button_b_desc, prize_desc)
        matches_a = BUTTON_REGEX.match(button_a_desc)
        matches_b = BUTTON_REGEX.match(button_b_desc)
        matches_p = PRIZE_REGEX.match(prize_desc)
        Machine.new(
          button_a: direction_from(*matches_a[1..]),
          button_b: direction_from(*matches_b[1..]),
          prize: location_from(*matches_p[1..]),
        )
      end

      def direction_from(xxx, yyy) = AOC::Direction.new(x: xxx.to_i, y: yyy.to_i)
      def location_from(xxx, yyy) = AOC::Location.new(x: xxx.to_i, y: yyy.to_i)
    end

    Machine = Data.define(:button_a, :button_b, :prize) do
      def cheapest_prize # rubocop:disable Metrics/AbcSize
        # solve for n and m: {
        #   n * button_a.x + m * button_b.x == prize.x
        #   n * button_a.y + m * button_b.y == prize.y
        # }
        #
        # example:
        #         Button A: X+94, Y+34
        #         Button B: X+22, Y+67
        #         Prize: X=8400, Y=5400
        # {
        #   94n + 22m = 8400
        #   34n + 67m = 5400
        # }
        #
        # Matrix Substitution
        # |94 22| |n|=|8400| ==> |94 22 8400| P
        # |34 67| |m|=|5400| ==> |34 67 5400| Q
        #
        # Q=34P-94Q
        #   ==> |94    22    8400|
        #   ==> | 0 -5550 -222000|
        # Q=Q/-5550
        #   ==> |94 22 8400|
        #   ==> | 0  1   40|
        # P=P-22Q
        #   ==> |94 0 7520|
        #   ==> | 0 1   40|
        # P=P/94
        #   ==> |1  0  80|
        #   ==> |0  1  40|
        #
        # n = 80, m = 40
        #
        # Inverse of a Matrix Version
        #
        # |94 22|*|n|=|8400|   or (B*C=P) thus C=B.inverse*P
        # |34 67| |m| |5400|

        matrix_buttons = ::Matrix[
          [button_a.x, button_b.x],
          [button_a.y, button_b.y],
        ]

        matrix_prize = Matrix[[prize.x], [prize.y]]

        matrix_counts = matrix_buttons.inverse * matrix_prize

        a_count = matrix_counts[0, 0]
        b_count = matrix_counts[1, 0]
        # non-integer values imply it takes a fraction of a button push
        # therefore no solution
        return nil unless a_count.to_i == a_count
        return nil unless b_count.to_i == b_count

        (3 * a_count.to_i) + b_count.to_i
      end
    end

    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def parse_input
      puzzle_input.split("\n\n").map do |desc|
        MachineBuilder.new.build_machine_from_description(*desc.lines(chomp: true))
      end
    end

    def part_a
      machines = parse_input
      machines.map(&:cheapest_prize).compact.sum.to_s
      # 29877 instant
    end

    def part_b
      # prizes are actually 10000000000000 (10 trillion) further on the X and Y axes
      machines = parse_input.map do |machine|
        Machine.new(
          button_a: machine.button_a,
          button_b: machine.button_b,
          prize: AOC::Location.new(
            x: machine.prize.x + 10_000_000_000_000,
            y: machine.prize.y + 10_000_000_000_000,
          ),
        )
      end
      machines.map(&:cheapest_prize).compact.sum.to_s
      # 99423413811305 instant
    end

    private

    attr_reader :puzzle_input
  end
end
