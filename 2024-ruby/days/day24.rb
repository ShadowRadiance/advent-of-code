# frozen_string_literal: true

module Days
  class Day24
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def part_a
      sys = System.new(**parse_input)
      sys.pull_z
      sys.value.to_s
      #   63168299811048 in 0.05s
    end

    def part_b
      # system is trying to
      # treat the X-bits as one number (x00 is LSB)
      #   and the Y-bits as one number (y00 is LSB)
      #   and add those two numbers together
      #    to output to Z-bits (z00 is LSB)
      # it doesn't work because some gates' output wires were swapped
      #
      # ** exactly four pairs of gates had output wires swapped
      # ** a gate can only be in at most one such pair
      #
      # DETERMINE THE FOUR SWAPPED OUTPUT WIRES
      # (AND THE FOUR WIRES WITH WHICH THEY WERE SWAPPED)
      # SORT THE WIRES BY NAME AND OUTPUT THEM JOINED WITH COMMAS
      #
      # There are 222 gates in the LIVE data
      # first choose 2 from 222 (222C2=24531)
      #  then choose 2 from 220 (220C2=24090)
      #  then choose 2 from 218 (218C2=23653)
      #  then choose 2 from 216 (216C2=23220)
      # ==> 24531*24090*23653*23220
      # ==> 324_564_114_035_561_400 variations
      # Brute force is *probably* not a great approach
      #
      # Since we know the desired output (X+Y),
      #   we can maybe test for which Z bits are incorrect
      #   to narrow down the bad outputs

      # https://blog.jverkamp.com/2024/12/24/aoc-2024-day-24-ripple-carrinator/
      # has a lovely explanation of the way each set should be essentially the same
      # to implement a "ripple carry adder", and if you output the graph with GraphViz
      # you can see where it isn't and that all the swaps are "local"
      # ==> So what we need to is basically go through each bit, build what the
      # ==> structure should be, and check that we have that!
      #
      # https://www.bytesizego.com/blog/aoc-day24-golang
      # also has a nice explanation (referencing *another* post)
      # https://www.reddit.com/r/adventofcode/comments/1hla5ql/2024_day_24_part_2_a_guide_on_the_idea_behind_the/
      # that helps find the rules for finding the bad wires in a "ripple carry adder"
      #
      # 1. if the gate outputs to Z, the operation must be XOR (unless it is the last Z-bit)
      # 2. if the gate outputs to anything but Z, and the inputs are not X,Y, then it must be AND or OR but not XOR
      # 3. if an XOR gate has inputs X,Y, it must output to a wire that is input to another XOR gate
      # 4. if an AND gate, it must output to a wire that is input to an OR gate
      #
      # We'll reimplement the www.bytesizego.com version for part b

      sys = System.new(**parse_input)
      faulty = sys.validate_ripple_carry_adder_rules
      faulty.sort.join(",")
    end

    Gate = Struct.new(:operation, :input_wires, :output_wire, :output, keyword_init: true)

    # x00 AND y00 -> z00
    GATE_REGEX = /^([a-z0-9]{3}) (AND|OR|XOR) ([a-z0-9]{3}) -> ([a-z0-9]{3})$/
    OPERATIONS = {
      "AND" => "AND",
      "XOR" => "XOR",
      "OR" => "ORR",
    }.freeze

    def parse_input
      wire_lines, gate_lines = @puzzle_input.split("\n\n")

      {
        wires: wire_lines.lines(chomp: true).to_h do |line|
          name, value = line.split(": ")
          [name, value.to_i]
        end,
        gates: gate_lines.lines(chomp: true).map do |line|
          matches = GATE_REGEX.match(line)
          Gate.new(
            operation: OPERATIONS[matches[2]],
            input_wires: [matches[1], matches[3]],
            output_wire: matches[4],
            output: nil,
          )
        end,
      }
    end

    class System
      attr_reader :wires, :gates

      # @param [Hash<String, Integer>] wires The initial values on each wire
      # @param [Array<Gate>] gates A list of gates connecting a pair of input wires to an output wire
      def initialize(wires:, gates:)
        @wires = wires # initialized wires
        @gates = gates
        @gates_by_output_wire = {}
        @input_wires = {}

        gates.each do |gate|
          keys = @wires.keys

          # initialize the wires that weren't mentioned in the parameters
          gate.input_wires.each do |wire_id|
            @wires[wire_id] = nil unless keys.include?(wire_id)
          end
          @wires[gate.output_wire] = nil unless keys.include?(gate.output_wire)

          # record each input_wire -> gate relationship
          gate.input_wires.each do |wire_id|
            @input_wires[wire_id] ||= []
            @input_wires[wire_id] << gate
          end

          # record the output_wire -> gate relationship
          @gates_by_output_wire[gate.output_wire] = gate
        end
      end

      def pull_z
        z_wire_ids.each { |z_wire_id| evaluate_wire(z_wire_id) }
      end

      def gate_outputting_to(wire_id)
        @gates_by_output_wire[wire_id]
      end

      def evaluate_wire(wire_id)
        @wires[wire_id] = evaluate_gate(gate_outputting_to(wire_id)) if @wires[wire_id].nil?
        @wires[wire_id]
      end

      def evaluate_gate(gate)
        gate.output ||= case gate.operation
                        when "AND"
                          evaluate_wire(gate.input_wires[0]) & evaluate_wire(gate.input_wires[1])
                        when "ORR"
                          evaluate_wire(gate.input_wires[0]) | evaluate_wire(gate.input_wires[1])
                        when "XOR"
                          evaluate_wire(gate.input_wires[0]) ^ evaluate_wire(gate.input_wires[1])
                        else raise TypeError, "invalid Gate operation"
                        end
      end

      def value
        binary_z
      end

      def binary_z
        z_array.join.to_i(2)
      end

      def z_array
        z_wire_ids.map { @wires[it] }
      end

      def z_wire_ids
        @z_wire_ids ||= @wires.keys.grep(/z\d\d/).sort.reverse
      end

      def validate_ripple_carry_adder_rules
        faulty = []
        @gates.each do |gate|
          if test_1_failed?(gate)
            faulty << gate.output_wire
            next
          end

          if test_2_failed?(gate)
            faulty << gate.output_wire
            next
          end

          if test_3_failed?(gate)
            faulty << gate.output_wire
            next
          end

          if test_4_failed?(gate)
            faulty << gate.output_wire
            next
          end
        end

        faulty
      end

      def test_1_failed?(gate)
        # If the output of a gate is a zNN, then the operation has to be XOR unless it is the last bit.
        z_hi_bit_wire_id = z_wire_ids.first

        z_wire?(gate.output_wire) &&
          gate.operation != "XOR" &&
          gate.output_wire != z_hi_bit_wire_id
      end

      def test_2_failed?(gate)
        # If the output of a gate is not z and the inputs are not x, y then it has to be AND / OR, but not XOR.
        !z_wire?(gate.output_wire) &&
          !x_wire?(gate.input_wires[0]) && !y_wire?(gate.input_wires[0]) &&
          !x_wire?(gate.input_wires[1]) && !y_wire?(gate.input_wires[1]) &&
          gate.operation == "XOR"
      end

      def test_3_failed?(gate)
        # If you have a XOR gate with inputs x, y, there must be another XOR gate with this gate as an input.
        # Search through all gates for an XOR-gate with this gate as an input; if it does not exist, your (original) XOR gate is faulty.
        return false unless test_3_gate?(gate)

        return true unless @input_wires.key?(gate.output_wire)

        valid = false
        @input_wires[gate.output_wire].each do |poss_gate|
          if poss_gate.operation == "XOR"
            valid = true
            break
          end
        end

        !valid
      end

      def test_3_gate?(gate)
        # an XOR gate with inputs x, y
        a = gate.input_wires[0]
        b = gate.input_wires[1]
        gate.operation == "XOR" &&
          ((x_wire?(a) && y_wire?(b)) || (y_wire?(a) && x_wire?(b))) &&
          a != "x00" && b != "x00" && a != "y00" && b != "y00"
      end

      def test_4_failed?(gate)
        # if you have an AND-gate, there must be an OR-gate with this gate as an input.
        # if that gate doesn't exist, the original AND gate is faulty.
        return false unless test_4_gate?(gate)

        return true unless @input_wires.key?(gate.output_wire)

        valid = false
        @input_wires[gate.output_wire].each do |poss_gate|
          if poss_gate.operation == "ORR"
            valid = true
            break
          end
        end

        !valid
      end

      def test_4_gate?(gate)
        a = gate.input_wires[0]
        b = gate.input_wires[1]

        gate.operation == "AND" &&
          ((x_wire?(a) && y_wire?(b)) || (y_wire?(a) && x_wire?(b))) &&
          a != "x00" && b != "x00" && a != "y00" && b != "y00"
      end

      def z_wire?(wire_id)
        wire_id[0] == "z"
      end

      def y_wire?(wire_id)
        wire_id[0] == "y"
      end

      def x_wire?(wire_id)
        wire_id[0] == "x"
      end
    end
  end
end
