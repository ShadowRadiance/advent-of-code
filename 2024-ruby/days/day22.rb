# frozen_string_literal: true

module Days
  class Day22
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def part_a
      results = @puzzle_input.lines(chomp: true).map do |line|
        SecretNumberGenerator.new(base: line.to_i).generate_next_n(2000)
      end
      results.sum.to_s
      # 18317943467 in 0.8s
    end

    def part_b
      "PENDING_B"
    end

    class SecretNumberGenerator
      def initialize(base:)
        @base = base
        @current = base
      end

      PRIMARY   = 64   # = 0b0000_0100_0000 # X * P === X<<6
      SECONDARY = 32   # = 0b0000_0010_0000 # X / S === X>>5
      TERTIARY  = 2048 # = 0b1000_0000_0000 # X * T === X<<11

      def generate_next
        secret = @current
        # secret * primary === secret << 6
        secret = prune(mix(secret, secret * PRIMARY))
        # secret / secondary === secret >> 5
        secret = prune(mix(secret, secret / SECONDARY))
        # secret * tertiary === secret << 11
        secret = prune(mix(secret, secret * TERTIARY))
        @current = secret
      end

      def generate_next_n(_n)
        2000.times { generate_next }
        @current
      end

      def mix(xxx, yyy)
        xxx ^ yyy # bitwise xor

        # since we always prune after we mix, only the last 24 bits matter
      end

      def prune(xxx)
        xxx % 16_777_216
        # 16_777_216 decimal
        # = 0x1000000 hex
        # = 0b0000_0001_0000_0000_0000_0000_0000_0000 binary
        # i.e. "keep the last 24 bits"
      end
    end
  end
end
