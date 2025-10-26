# frozen_string_literal: true

require_relative "../../days/day13"

RSpec.describe "Days::Day13" do
  let(:day_runner) { Days::Day13.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      Button A: X+94, Y+34
      Button B: X+22, Y+67
      Prize: X=8400, Y=5400

      Button A: X+26, Y+66
      Button B: X+67, Y+21
      Prize: X=12748, Y=12176

      Button A: X+17, Y+86
      Button B: X+84, Y+37
      Prize: X=7870, Y=6450

      Button A: X+69, Y+23
      Button B: X+27, Y+71
      Prize: X=18641, Y=10279
    INPUT
  end

  describe "Machine" do
    it "== compares by ivar" do
      a = Days::Day13::Machine.new(
        button_a: AOC::Direction.new(1, 2),
        button_b: AOC::Direction.new(3, 4),
        prize: AOC::Location.new(5, 6),
      )
      b = Days::Day13::Machine.new(
        button_a: AOC::Direction.new(1, 2),
        button_b: AOC::Direction.new(3, 4),
        prize: AOC::Location.new(5, 6),
      )
      expect(a == b).to be(true)
    end

    describe "#cheapest_prize" do
      it do
        machines = day_runner.parse_input
        expect(machines.map(&:cheapest_prize)).to eq([280, nil, 200, nil])
      end
    end
  end

  describe "#parse_input" do
    it "returns an array of machines" do
      expect(day_runner.parse_input).to eq(
        [
          Days::Day13::Machine.new(
            button_a: AOC::Direction.new(x: 94, y: 34),
            button_b: AOC::Direction.new(x: 22, y: 67),
            prize: AOC::Location.new(x: 8400, y: 5400),
          ),
          Days::Day13::Machine.new(
            button_a: AOC::Direction.new(x: 26, y: 66),
            button_b: AOC::Direction.new(x: 67, y: 21),
            prize: AOC::Location.new(x: 12_748, y: 12_176),
          ),
          Days::Day13::Machine.new(
            button_a: AOC::Direction.new(x: 17, y: 86),
            button_b: AOC::Direction.new(x: 84, y: 37),
            prize: AOC::Location.new(x: 7870, y: 6450),
          ),
          Days::Day13::Machine.new(
            button_a: AOC::Direction.new(x: 69, y: 23),
            button_b: AOC::Direction.new(x: 27, y: 71),
            prize: AOC::Location.new(x: 18_641, y: 10_279),
          ),
        ],
      )
    end
  end

  describe "#part_a" do
    it "returns the correct value for part A" do
      expect(day_runner.part_a).to eq "480"
    end
  end

  describe "#part_b" do
    it "returns the correct value for part B" do
      expect(day_runner.part_b).to eq "PENDING_B"
    end
  end
end
