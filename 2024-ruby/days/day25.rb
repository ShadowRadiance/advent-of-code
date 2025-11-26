# frozen_string_literal: true

require_relative "../lib/aoc/grid"

module Days
  class Day25
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def part_a
      locks, keys = parse_input

      fits = []
      locks.each do |lock|
        keys.each do |key|
          fits << [lock, key] unless overlap(lock, key)
        end
      end
      fits.length.to_s
      # 2586 in 0.067s
    end

    def part_b
      "PENDING_B"
    end

    def parse_input
      locks = []
      keys = []
      schematics = @puzzle_input.split("\n\n")
      schematics.each do |schematic|
        lock, key = parse_schematic(schematic)
        locks << lock if lock
        keys << key if key
      end
      [locks, keys]
    end

    TOP_LEFT = AOC::Location.new(0, 0)

    def parse_schematic(schematic)
      grid = AOC::Grid.new(schematic.lines(chomp: true).map(&:chars))
      is_lock = grid.value_at(TOP_LEFT) == "#"

      pins = (0...grid.num_cols).map do |column_number|
        grid.column(column_number).count("#") - 1
      end

      is_lock ? [pins, nil] : [nil, pins]
    end

    MAX_HEIGHT = 5

    def overlap(lock, key)
      lock.length.times do |index|
        return true if lock[index] + key[index] > MAX_HEIGHT
      end
      false
    end
  end
end
