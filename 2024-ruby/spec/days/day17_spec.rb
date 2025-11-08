# frozen_string_literal: true

require_relative "../../days/day17"

RSpec.describe "Days::Day17" do
  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe "Computer" do
    let(:register_a) { 0 }
    let(:register_b) { 0 }
    let(:register_c) { 0 }
    let(:registers) { { register_a: register_a, register_b: register_b, register_c: register_c } }
    let(:computer) { Days::Day17::Computer.new(**registers) }
    let(:output) { [] }

    before { computer.run(program, output: output) }

    context "with {C:9} and [2,6]" do
      let(:register_c) { 9 }
      let(:program) { [2, 6] }

      it { expect(computer.registers[:register_b]).to eq(1) }
    end

    context "with {A:10} and [5, 0, 5, 1, 5, 4]" do
      let(:register_a) { 10 }
      let(:program) { [5, 0, 5, 1, 5, 4] }

      it { expect(output).to eq([0, 1, 2]) }
    end

    context "with {A:2024} and [0, 1, 5, 4, 3, 0]" do
      let(:register_a) { 2024 }
      let(:program) { [0, 1, 5, 4, 3, 0] }

      # ADV 1 OUT 4 JNZ 0
      # ===
      #   A = (A/2**1).to_i
      #   OUTPUT A
      #   IF A!=0 GOTO 0

      it { expect(output).to eq([4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0]) }
      it { expect(computer.registers[:register_a]).to eq(0) }
    end

    context "with {B:29} and [1, 7]" do
      let(:register_b) { 29 }
      let(:program) { [1, 7] }

      # If register B contains 29, the program 1,7 would set register B to 26.
      it { expect(computer.registers[:register_b]).to eq(26) }
    end

    context "with {B:2024,C:43_690} and [4,0]" do
      let(:register_b) { 2024 }
      let(:register_c) { 43_690 }
      let(:program) { [4, 0] }

      it { expect(computer.registers[:register_b]).to eq(44_354) }
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers

  describe "day runner" do
    let(:day_runner) { Days::Day17.new(puzzle_input) }

    describe "#part_a" do
      let(:puzzle_input) do
        <<~INPUT
          Register A: 729
          Register B: 0
          Register C: 0

          Program: 0,1,5,4,3,0
        INPUT
      end

      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "4,6,3,5,6,3,5,2,1,0"
      end
    end

    describe "#part_b" do
      let(:puzzle_input) do
        <<~INPUT
          Register A: 2024
          Register B: 0
          Register C: 0

          Program: 0,3,5,4,3,0
        INPUT
      end

      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "117440"
      end
    end
  end
end
