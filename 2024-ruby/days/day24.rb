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
      "PENDING_B"
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
      attr_reader :wires

      # @param [Hash<String, Integer>] wires The initial values on each wire
      # @param [Array<Gate>] gates A list of gates connecting a pair of input wires to an output wire
      def initialize(wires:, gates:)
        @wires = wires # initialized wires
        @gates = gates
        @wire_inputs = {}
        gates.each do |gate|
          keys = @wires.keys

          # initialize the wires that weren't mentioned in the parameters
          [gate.output_wire, *gate.input_wires].each do |wire_id|
            @wires[wire_id] = nil unless keys.include?(wire_id)
          end

          # record the output_wire -> gate relationship
          @wire_inputs[gate.output_wire] = gate
        end
      end

      def pull_z
        z_wire_ids.each { |z_wire_id| evaluate_wire(z_wire_id) }
      end

      def gate_outputting_to(wire_id)
        @wire_inputs[wire_id]
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
    end
  end
end
