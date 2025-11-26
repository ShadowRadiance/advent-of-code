# frozen_string_literal: true

require_relative "../../days/day24"

RSpec.describe "Days::Day24" do
  let(:day_runner) { Days::Day24.new(puzzle_input) }

  let(:simple_input) do
    <<~INPUT
      x00: 1
      x01: 1
      x02: 1
      y00: 0
      y01: 1
      y02: 0

      x00 AND y00 -> z00
      x01 XOR y01 -> z01
      x02 OR y02 -> z02
    INPUT
  end

  let(:complex_input) do
    <<~INPUT
      x00: 1
      x01: 0
      x02: 1
      x03: 1
      x04: 0
      y00: 1
      y01: 1
      y02: 1
      y03: 1
      y04: 1

      ntg XOR fgs -> mjb
      y02 OR x01 -> tnw
      kwq OR kpj -> z05
      x00 OR x03 -> fst
      tgd XOR rvg -> z01
      vdt OR tnw -> bfw
      bfw AND frj -> z10
      ffh OR nrd -> bqk
      y00 AND y03 -> djm
      y03 OR y00 -> psh
      bqk OR frj -> z08
      tnw OR fst -> frj
      gnj AND tgd -> z11
      bfw XOR mjb -> z00
      x03 OR x00 -> vdt
      gnj AND wpb -> z02
      x04 AND y00 -> kjc
      djm OR pbm -> qhw
      nrd AND vdt -> hwm
      kjc AND fst -> rvg
      y04 OR y02 -> fgs
      y01 AND x02 -> pbm
      ntg OR kjc -> kwq
      psh XOR fgs -> tgd
      qhw XOR tgd -> z09
      pbm OR djm -> kpj
      x03 XOR y03 -> ffh
      x00 XOR y04 -> ntg
      bfw OR bqk -> z06
      nrd XOR fgs -> wpb
      frj XOR qhw -> z04
      bqk OR frj -> z07
      y03 OR x01 -> nrd
      hwm AND bqk -> z03
      tgd XOR rvg -> z12
      tnw OR pbm -> gnj
    INPUT
  end

  describe "#parse_input" do
    context "with simple input" do
      let(:puzzle_input) { simple_input }

      it "parses the input into wires and gates" do
        expect(day_runner.parse_input).to eq(
          {
            wires: {
              "x00" => 1,
              "x01" => 1,
              "x02" => 1,
              "y00" => 0,
              "y01" => 1,
              "y02" => 0,
            },

            gates: [
              Days::Day24::Gate.new(operation: "AND", input_wires: %w[x00 y00], output_wire: "z00", output: nil),
              Days::Day24::Gate.new(operation: "XOR", input_wires: %w[x01 y01], output_wire: "z01", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[x02 y02], output_wire: "z02", output: nil),
            ],
          },
        )
      end
    end

    context "with complex input" do
      let(:puzzle_input) { complex_input }

      it "parses the input into wires and gates" do
        expect(day_runner.parse_input).to eq(
          {
            wires: {
              "x00" => 1,
              "x01" => 0,
              "x02" => 1,
              "x03" => 1,
              "x04" => 0,
              "y00" => 1,
              "y01" => 1,
              "y02" => 1,
              "y03" => 1,
              "y04" => 1,
            },
            gates: [
              Days::Day24::Gate.new(operation: "XOR", input_wires: %w[ntg fgs], output_wire: "mjb", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[y02 x01], output_wire: "tnw", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[kwq kpj], output_wire: "z05", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[x00 x03], output_wire: "fst", output: nil),
              Days::Day24::Gate.new(operation: "XOR", input_wires: %w[tgd rvg], output_wire: "z01", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[vdt tnw], output_wire: "bfw", output: nil),
              Days::Day24::Gate.new(operation: "AND", input_wires: %w[bfw frj], output_wire: "z10", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[ffh nrd], output_wire: "bqk", output: nil),
              Days::Day24::Gate.new(operation: "AND", input_wires: %w[y00 y03], output_wire: "djm", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[y03 y00], output_wire: "psh", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[bqk frj], output_wire: "z08", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[tnw fst], output_wire: "frj", output: nil),
              Days::Day24::Gate.new(operation: "AND", input_wires: %w[gnj tgd], output_wire: "z11", output: nil),
              Days::Day24::Gate.new(operation: "XOR", input_wires: %w[bfw mjb], output_wire: "z00", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[x03 x00], output_wire: "vdt", output: nil),
              Days::Day24::Gate.new(operation: "AND", input_wires: %w[gnj wpb], output_wire: "z02", output: nil),
              Days::Day24::Gate.new(operation: "AND", input_wires: %w[x04 y00], output_wire: "kjc", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[djm pbm], output_wire: "qhw", output: nil),
              Days::Day24::Gate.new(operation: "AND", input_wires: %w[nrd vdt], output_wire: "hwm", output: nil),
              Days::Day24::Gate.new(operation: "AND", input_wires: %w[kjc fst], output_wire: "rvg", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[y04 y02], output_wire: "fgs", output: nil),
              Days::Day24::Gate.new(operation: "AND", input_wires: %w[y01 x02], output_wire: "pbm", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[ntg kjc], output_wire: "kwq", output: nil),
              Days::Day24::Gate.new(operation: "XOR", input_wires: %w[psh fgs], output_wire: "tgd", output: nil),
              Days::Day24::Gate.new(operation: "XOR", input_wires: %w[qhw tgd], output_wire: "z09", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[pbm djm], output_wire: "kpj", output: nil),
              Days::Day24::Gate.new(operation: "XOR", input_wires: %w[x03 y03], output_wire: "ffh", output: nil),
              Days::Day24::Gate.new(operation: "XOR", input_wires: %w[x00 y04], output_wire: "ntg", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[bfw bqk], output_wire: "z06", output: nil),
              Days::Day24::Gate.new(operation: "XOR", input_wires: %w[nrd fgs], output_wire: "wpb", output: nil),
              Days::Day24::Gate.new(operation: "XOR", input_wires: %w[frj qhw], output_wire: "z04", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[bqk frj], output_wire: "z07", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[y03 x01], output_wire: "nrd", output: nil),
              Days::Day24::Gate.new(operation: "AND", input_wires: %w[hwm bqk], output_wire: "z03", output: nil),
              Days::Day24::Gate.new(operation: "XOR", input_wires: %w[tgd rvg], output_wire: "z12", output: nil),
              Days::Day24::Gate.new(operation: "ORR", input_wires: %w[tnw pbm], output_wire: "gnj", output: nil),
            ],
          },
        )
      end
    end
  end

  describe "#part_a" do
    let(:puzzle_input) { complex_input }

    it "returns the correct value for part A" do
      expect(day_runner.part_a).to eq "2024"
    end
  end

  describe "#part_b" do
    let(:puzzle_input) do
      <<~INPUT
        x00: 0
        x01: 1
        x02: 0
        x03: 1
        x04: 0
        x05: 1
        y00: 0
        y01: 0
        y02: 1
        y03: 1
        y04: 0
        y05: 1

        x00 AND y00 -> z05
        x01 AND y01 -> z02
        x02 AND y02 -> z01
        x03 AND y03 -> z03
        x04 AND y04 -> z04
        x05 AND y05 -> z00
      INPUT
    end

    it "returns the correct value for part B" do
      expect(day_runner.part_b).to eq "z00,z01,z02,z05"
    end
  end
end
