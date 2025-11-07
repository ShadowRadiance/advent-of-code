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

    def part_b_old
      computer, program = parse_input
      successful_a = nil
      (1..).each do |initial_a|
        # puts "Testing A:#{initial_a}"
        output_buffer = CheckedOutputBuffer.new(desired: program)
        computer.reset(register_a: initial_a)
        computer.run(program, output: output_buffer)
        next unless output_buffer.buffer == program

        successful_a = initial_a
        break
      rescue CheckedOutputBuffer::InvalidProgram => _e
        # puts "InvalidProgram"
        next
      end
      successful_a.to_s
      # did not complete after 20m
    end

    def part_b(testing: false)
      computer, program = parse_input

      # if testing
      #   # program == [0, 3, 5, 4, 3, 0]
      #   # ===
      #   # 0,3: adv C(3) ==> adv 3 ==> A = (A/2**3).to_i
      #   # 5,4: out C(4) ==> out A ==> OUTPUT A%8
      #   # 3,0: jnz L(0) ==> jnz 0 ==> IF A!=0 GOTO 0
      #   #
      #   # KEY FACTS --> A = A/8 each time
      #   #           --> 1 OUTPUT PER LOOP
      #   #           --> WE NEED 6 OUTPUTS
      #   # INITIAL A MUST BE some_value+(0..7)
      #   # IT NEEDS TO BE DIVIDED BY 8, 6 TIMES, TO GET TO 0
      #   # some_value should be 8**6
      #   # INITIAL A MUST BE 8**6 + (0..7)
      # else
      #   # program = 2,4,1,1,7,5,1,5,4,5,0,3,5,5,3,0
      #   # ===
      #   # 2,4: bst C(4) ==> bst A ==> B = A%8
      #   # 1,1: bxl L(1) ==> bxl 1 ==> B = B^00000001
      #   # 7,5: cdv C(5) ==> cdv B ==> C = (A/2**B).to_i
      #   # 1,5: bxl L(5) ==> bxl 5 ==> B = B^00000101
      #   # 4,5: bxc ____ ==> bxc _ ==> B = B^C
      #   # 0,3: adv C(3) ==> adv 3 ==> A = (A/2**3).to_i
      #   # 5,5: out C(5) ==> out B ==> OUTPUT B%8
      #   # 3,0: jnz L(0) ==> jnz 0 ==> IF A!=0 GOTO 0
      #   #
      #   # KEY FACTS --> A = A/8 each time
      #   #           --> 1 OUTPUT PER LOOP
      #   #           --> WE NEED 16 OUTPUTS
      #   # INITIAL A MUST BE AT LEAST some_value
      #   # IT NEEDS TO BE DIVIDED BY 8, 16 TIMES, TO GET TO 0
      #   # some_value should be 8**16
      #   # INITIAL A MUST BE 8**16 .. (8**17)-1
      # end

      lowest = 8**(program.length - 1)
      highest = (8**program.length) - 1
      successful_a = nil

      (lowest..highest).each do |initial_a|
        print "."
        output_buffer = CheckedOutputBuffer.new(desired: program)
        computer.reset(register_a: initial_a)
        computer.run(program, output: output_buffer)
        next unless output_buffer.buffer == program

        successful_a = initial_a
        break
      rescue CheckedOutputBuffer::InvalidProgram => _e
        next
      end
      successful_a.to_s
      # did not complete after 1h30m
    end

    class CheckedOutputBuffer
      class InvalidProgram < RuntimeError; end

      attr_reader :desired, :buffer

      def initialize(desired:)
        @desired = desired
        @buffer = []
      end

      def <<(value)
        @buffer << value
        # puts "Buffer = #{@buffer.join(',')}"
        invalid = @buffer != @desired[0...@buffer.length]
        # puts "[#{@buffer.join(',')}] != [#{@desired[0...@buffer.length].join(',')}] == #{invalid}"
        raise InvalidProgram if invalid
      end
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
