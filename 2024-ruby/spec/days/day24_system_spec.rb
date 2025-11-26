# frozen_string_literal: true

require_relative "../../days/day24"

RSpec.describe "Days::Day24::System" do
  let(:sys) { Days::Day24::System.new(wires: wires, gates: gates) }

  context "with a simple set of z wires" do
    let(:wires) { { "z00" => 1, "z01" => 0, "z02" => 1, "z03" => 1 } }
    let(:gates) { [] }

    describe "#z_array" do
      it "determines the ordered z_array" do
        expect(sys.z_array).to eq([1, 1, 0, 1])
      end
    end

    describe "#binary_z" do
      it "determines the binary value of the z array" do
        expect(sys.binary_z).to eq(0b1101)
      end
    end
  end

  context "with a complex set of gates and wires" do
    let(:wires) do
      {
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
      }
    end
    let(:gates) do
      [
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
      ]
    end

    describe "#pull_z" do
      it "pulls the value for each z from the connected gates/wires" do
        sys.pull_z
        expect(sys.wires).to eq(
          {
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

            "bfw" => 1,
            "bqk" => 1,
            "djm" => 1,
            "ffh" => 0,
            "fgs" => 1,
            "frj" => 1,
            "fst" => 1,
            "gnj" => 1,
            "hwm" => 1,
            "kjc" => 0,
            "kpj" => 1,
            "kwq" => 0,
            "mjb" => 1,
            "nrd" => 1,
            "ntg" => 0,
            "pbm" => 1,
            "psh" => 1,
            "qhw" => 1,
            "rvg" => 0,
            "tgd" => 0,
            "tnw" => 1,
            "vdt" => 1,
            "wpb" => 0,
            "z00" => 0,
            "z01" => 0,
            "z02" => 0,
            "z03" => 1,
            "z04" => 0,
            "z05" => 1,
            "z06" => 1,
            "z07" => 1,
            "z08" => 1,
            "z09" => 1,
            "z10" => 1,
            "z11" => 0,
            "z12" => 0,
          },
        )
      end
    end
  end
end
