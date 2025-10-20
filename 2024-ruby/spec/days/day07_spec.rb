# frozen_string_literal: true

require_relative "../../days/day07"

RSpec.describe Days::Day07 do
  describe "DayRunner" do
    let(:day_runner) { described_class.new(puzzle_input) }

    let(:puzzle_input) do
      <<~INPUT
        190: 10 19
        3267: 81 40 27
        83: 17 5
        156: 15 6
        7290: 6 8 6 15
        161011: 16 10 13
        192: 17 8 14
        21037: 9 7 18 13
        292: 11 6 16 20
      INPUT
    end

    describe "#parse_input" do
      it "returns an array of calibrations" do
        expect(day_runner.parse_input).to eq(
          [
            { total: 190, operands: [10, 19] },
            { total: 3267, operands: [81, 40, 27] },
            { total: 83, operands: [17, 5] },
            { total: 156, operands: [15, 6] },
            { total: 7290, operands: [6, 8, 6, 15] },
            { total: 161_011, operands: [16, 10, 13] },
            { total: 192, operands: [17, 8, 14] },
            { total: 21_037, operands: [9, 7, 18, 13] },
            { total: 292, operands: [11, 6, 16, 20] },
          ],
        )
      end
    end

    describe "#part_a" do
      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "3749"
      end
    end

    describe "#part_b" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "11387"
      end
    end
  end

  describe Days::Day07::Calibration do
    [
      {
        calibration: described_class.new(
          3267,
          [81, 40, 27],
          %i[+ *],
        ),
        operations: [
          [81, :+, 40, :+, 27],
          [81, :+, 40, :*, 27],
          [81, :*, 40, :+, 27],
          [81, :*, 40, :*, 27],
        ],
      },
      {
        calibration: described_class.new(
          190,
          [10, 19],
          %i[+ *],
        ),
        operations: [
          [10, :+, 19],
          [10, :*, 19],
        ],
      },
    ].each do |example|
      it "creates the expect possible operations" do
        expect(example[:calibration].possible_operations).to eq(example[:operations])
      end
    end
  end
end
