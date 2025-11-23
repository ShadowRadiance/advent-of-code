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
      # BUYERS
      #   offer is the "1s digit of the secret number" in bananas
      #
      # SELLER
      #   you give the seller monkey a single "sequence of 4 changes in offer"
      #   when the seller sees that sequence he will sell to the buyer,
      #   then that buyer goes away, and he talks to the next
      #
      # EXAMPLE
      #   Buyer 1 numbers, offers, and changes:
      #        123: 3 (n/a)
      #   15887950: 0 (-3)
      #   16495136: 6 (6)
      #     527345: 5 (-1)
      #     704524: 4 (-1)
      #    1553684: 4 (0)
      #   12683156: 6 (2)
      #   11100544: 4 (-2)
      #   12249484: 4 (0)
      #    7753432: 2 (-2)
      #   The sequence (-1,-1,0,2) would cause the seller to sell to Buyer1 at 6 bananas
      #
      # The problem is you can only give one sequence to the seller, and they
      # use it for all buyers.
      #
      # Find the largest total number of bananas
      #
      # THOUGHTS
      #   Since the offers can be any number from 0..9, the diffs can be
      #   any number from -9..9 (ie, 19 values)
      # There are "19*19*19*19 == 130321" diff sequences to check
      # Checking a sequence requires generating "enough" secrets to get the
      #   sequence for each starting base, and determining the sell price
      #   for each buyer for that sequence, add them up for a total for that
      #   sequence.

      # sequences_seen = {
      #   [d4,d3,d2,d1] => [buyer1offer, buyer2offer, ...]
      # }
      sequences_seen = {}
      buyers_offers = time(message: "Generate Buyer Offers: %fs") do
        buyers_bases = @puzzle_input.lines(chomp: true).map(&:to_i)
        generate_buyers_offers(buyers_bases, sequences_seen)
      end
      # Generate Buyer Offers: 0.010356 seconds TEST
      # Generate Buyer Offers: 9.947982 seconds LIVE

      sums = sequences_seen.transform_values do |offers|
        offers.compact.sum
      end

      k, v = sums.max_by { |_k, v| v }
      v.to_s

      # 2018 in 10.33s
    end

    OfferWithDiff = Data.define(:offer, :last_4_diffs)

    def generate_buyers_offers(buyers_bases, sequences_seen) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      number_of_buyers = buyers_bases.count
      buyers_bases.map.with_index do |base, index|
        sng = SecretNumberGenerator.new(base: base)

        previous_offer_4 = nil
        previous_offer_3 = nil
        previous_offer_2 = nil
        previous_offer_1 = base % 10

        (1..2000).map do
          offer = sng.generate_next % 10

          last_4_diffs = [
            diff(earlier: previous_offer_1, later: offer),
            diff(earlier: previous_offer_2, later: previous_offer_1),
            diff(earlier: previous_offer_3, later: previous_offer_2),
            diff(earlier: previous_offer_4, later: previous_offer_3),
          ]

          sequences_seen[last_4_diffs] ||= Array.new(number_of_buyers, nil)
          sequences_seen[last_4_diffs][index] ||= offer

          # shift the previous chain
          previous_offer_4 = previous_offer_3
          previous_offer_3 = previous_offer_2
          previous_offer_2 = previous_offer_1
          previous_offer_1 = offer

          OfferWithDiff.new(
            offer: offer,
            last_4_diffs: last_4_diffs,
          )
        end
      end
    end

    def diff(earlier:, later:)
      return nil if earlier.nil? || later.nil?

      later - earlier
    end

    def permutation_possible?(perm)
      # the combination cannot go outside the range -9..9
      combination = perm[0] + perm[1]
      return false if combination < -9 || combination > 9

      combination += perm[2]
      return false if combination < -9 || combination > 9

      combination += perm[3]
      return false if combination < -9 || combination > 9

      true
    end

    def time(message: nil)
      start = Time.now

      result = yield

      finish = Time.now
      puts message % (finish - start) if message

      result
    end

    class SecretNumberGenerator
      class LoopedError < StandardError; end

      def initialize(base:)
        @base = base
        @current = base
      end

      PRIMARY   = 64          # = 0b0000_0100_0000                          # X * P === X<<6
      SECONDARY = 32          # = 0b0000_0010_0000                          # X / S === X>>5
      TERTIARY  = 2048        # = 0b1000_0000_0000                          # X * T === X<<11
      PRUNER    = 16_777_216  # = 0b0000_0001_0000_0000_0000_0000_0000_0000 # X % PRUNER === X & 1111_1111_1111_1111

      def generate_next
        secret = @current
        # secret * primary === secret << 6
        secret = prune(mix(secret, secret * PRIMARY))
        # secret / secondary === secret >> 5
        secret = prune(mix(secret, secret / SECONDARY))
        # secret * tertiary === secret << 11
        secret = prune(mix(secret, secret * TERTIARY))

        raise LoopedError if secret == @base

        @current = secret
      end

      def generate_next_n(nnn)
        nnn.times { generate_next }
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
