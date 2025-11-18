# frozen_string_literal: true

require_relative "../../days/day05"

RSpec.describe "Days::Day05" do
  let(:day_runner) { Days::Day05.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      47|53
      97|13
      97|61
      97|47
      75|29
      61|13
      75|53
      29|13
      97|29
      53|29
      61|53
      97|53
      61|29
      47|13
      75|47
      97|75
      47|61
      75|61
      47|29
      75|13
      53|13

      75,47,61,53,29
      97,61,53,29,13
      75,29,13
      75,97,47,61,53
      61,13,29
      97,13,75,29,47
    INPUT
  end

  describe ".parse_input" do
    it "returns a hash with the rules and updates" do
      expect(day_runner.parse_input).to eq(
        {
          rules: [
            { earlier: 47, later: 53 },
            { earlier: 97, later: 13 },
            { earlier: 97, later: 61 },
            { earlier: 97, later: 47 },
            { earlier: 75, later: 29 },
            { earlier: 61, later: 13 },
            { earlier: 75, later: 53 },
            { earlier: 29, later: 13 },
            { earlier: 97, later: 29 },
            { earlier: 53, later: 29 },
            { earlier: 61, later: 53 },
            { earlier: 97, later: 53 },
            { earlier: 61, later: 29 },
            { earlier: 47, later: 13 },
            { earlier: 75, later: 47 },
            { earlier: 97, later: 75 },
            { earlier: 47, later: 61 },
            { earlier: 75, later: 61 },
            { earlier: 47, later: 29 },
            { earlier: 75, later: 13 },
            { earlier: 53, later: 13 },
          ],
          updates: [
            [75, 47, 61, 53, 29],
            [97, 61, 53, 29, 13],
            [75, 29, 13],
            [75, 97, 47, 61, 53],
            [61, 13, 29],
            [97, 13, 75, 29, 47],
          ],
        },
      )
    end
  end

  describe "#part_a" do
    context "with the sample data" do
      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "143"
      end
    end
  end

  describe "#part_b" do
    context "with the sample data" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "123"
      end
    end
  end
end
