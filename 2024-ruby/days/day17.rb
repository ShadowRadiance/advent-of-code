# frozen_string_literal: true

module Days
  class Day17
    attr_reader :puzzle_input

    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def parse_input
      computer_desc, program_desc = puzzle_input.split("\n\n")

      registers = computer_desc.lines(chomp: true).to_h do |line|
        k, v = line.split(": ")
        [k, v.to_i]
      end

      computer = Computer.new(
        register_a: registers["Register A"],
        register_b: registers["Register B"],
        register_c: registers["Register C"],
      )

      program = program_desc[9..].split(",").map(&:to_i)

      [computer, program]
    end

    def part_a
      output_buffer = []
      computer, program = parse_input
      computer.run(program, output: output_buffer)
      output_buffer.join(",")
    end

    def part_b
      computer, program = parse_input

      # https://elixirforum.com/t/advent-of-code-2024-day-17/68193/6
      # The way I solved part 2 is also by noticing that A is right-shifted 3-bits on each iteration.
      # So, starting at the end of the list I find all initial values of A in 0…7 that produces the
      # last byte of the program. Then moving up the list to the last 2 bytes, left-shift all the
      # existing values of A 3-bits, and add in 0…7, and record the list of A’s which produce the
      # last two bytes. …and so on up to include the whole program. Then take the min of that list.
      # It executes quite fast.

      list_of_initial_a_s = [0]

      (1..(program.length)).each do |n_cells|
        expected = program[-n_cells..]

        list_of_initial_a_s = list_of_initial_a_s.flat_map do |base|
          successes_for_initial_a_base(computer, base, program, n_cells, expected)
        end
      end

      list_of_initial_a_s
        .min
        .to_s
    end

    def successes_for_initial_a_base(computer, base, program, n_cells, expected)
      (0..7).filter_map do |last_3_bits|
        initial_a = (base << 3) + last_3_bits

        successful_run = run_successful?(computer, initial_a, program, n_cells, expected)

        successful_run ? initial_a : nil
      end
    end

    def run_successful?(computer, initial_a, program, n_cells, expected)
      computer.reset(register_a: initial_a)
      computer.run(program)
      computer.output[-n_cells..] == expected
    end

    class Computer
      OPCODES = %i[adv bxl bst jnz bxc out bdv cdv].freeze

      def initialize(register_a: 0, register_b: 0, register_c: 0)
        reset(register_a: register_a, register_b: register_b, register_c: register_c)
      end

      attr_reader :output

      def registers
        {
          register_a: @register_a,
          register_b: @register_b,
          register_c: @register_c,
        }
      end

      def reset(register_a: 0, register_b: 0, register_c: 0)
        @register_a = register_a
        @register_b = register_b
        @register_c = register_c

        @output = []
        @instruction_pointer = 0
        @halted = false
      end

      def run(program, output: nil)
        with_output(output || @output) do
          until @instruction_pointer >= program.length
            opcode = OPCODES[program[@instruction_pointer]]
            operand = program[@instruction_pointer + 1]
            @instruction_pointer += 2
            send(opcode, operand)
          end
        end
      end

      private

      def literal(operand)
        operand
      end

      def combo(operand)
        case operand
        when 0..3 then operand
        when 4 then @register_a
        when 5 then @register_b
        when 6 then @register_c
        else raise "combo(7) is reserved"
        end
      end

      def bitwise_xor(aaa, bbb)
        aaa ^ bbb
      end

      # The adv instruction (opcode 0) performs division. The numerator is the value in the A register.
      # The denominator is found by raising 2 to the power of the instruction's combo operand.
      # (So, an operand of 2 would divide A by 4 (2^2); an operand of 5 would divide A by 2^B.)
      # The result of the division operation is truncated to an integer and then written to the A register.
      def adv(operand)
        operand = combo(operand)
        @register_a = adv_value(operand)
      end

      def adv_value(value)
        (@register_a / 2.pow(value)).to_i
      end

      # The bxl instruction (opcode 1) calculates the bitwise XOR of register B and the instruction's literal operand,
      # then stores the result in register B.
      def bxl(operand)
        operand = literal(operand)
        @register_b = bitwise_xor(@register_b, operand)
      end

      # The bst instruction (opcode 2) calculates the value of its combo operand modulo 8
      # (thereby keeping only its lowest 3 bits), then writes that value to the B register.
      def bst(operand)
        operand = combo(operand)
        @register_b = operand % 8
      end

      # The jnz instruction (opcode 3) does nothing if the A register is 0. However, if the A register is not zero,
      # it jumps by setting the instruction pointer to the value of its literal operand; if this instruction jumps,
      # the instruction pointer is not increased by 2 after this instruction.
      def jnz(operand)
        return if @register_a.zero?

        operand = literal(operand)
        @instruction_pointer = operand
      end

      # The bxc instruction (opcode 4) calculates the bitwise XOR of register B and register C,
      # then stores the result in register B. (For legacy reasons, this instruction reads an operand but ignores it.)
      def bxc(operand)
        _unused = literal(operand)
        @register_b = bitwise_xor(@register_b, @register_c)
      end

      # The out instruction (opcode 5) calculates the value of its combo operand modulo 8, then outputs that value.
      # (If a program outputs multiple values, they are separated by commas.)
      def out(operand)
        operand = combo(operand)
        output << (operand % 8)
      end

      # The bdv instruction (opcode 6) works exactly like the adv instruction
      # except that the result is stored in the B register. (The numerator is still read from the A register.)
      def bdv(operand)
        operand = combo(operand)
        @register_b = adv_value(operand)
      end

      # The cdv instruction (opcode 7) works exactly like the adv instruction
      # except that the result is stored in the C register. (The numerator is still read from the A register.)
      def cdv(operand)
        operand = combo(operand)
        @register_c = adv_value(operand)
      end

      def with_output(new_output)
        @old_output = @output
        @output = new_output
        yield
      ensure
        @output = @old_output
      end
    end
  end
end
