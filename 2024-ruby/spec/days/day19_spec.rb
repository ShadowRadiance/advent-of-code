# frozen_string_literal: true

require_relative "../../days/day19"

RSpec.describe "Days::Day19" do
  let(:day_runner) { Days::Day19.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      r, wr, b, g, bwu, rb, gb, br

      brwrr
      bggr
      gbbr
      rrbgbr
      ubwu
      bwurrg
      brgr
      bbrgwb
    INPUT
  end

  describe "#parse_input" do
    it "returns an object with available patterns and desired designs" do
      expect(day_runner.parse_input).to have_attributes(
        {
          available_patterns: %w[r wr b g bwu rb gb br],
          desired_designs: %w[
            brwrr
            bggr
            gbbr
            rrbgbr
            ubwu
            bwurrg
            brgr
            bbrgwb
          ],
        },
      )
    end
  end

  describe "#part_a" do
    it "returns the correct value for part A" do
      expect(day_runner.part_a).to eq "6"
    end
  end

  describe "#part_b" do
    it "returns the correct value for part B" do
      expect(day_runner.part_b).to eq "PENDING_B"
    end
  end
end
