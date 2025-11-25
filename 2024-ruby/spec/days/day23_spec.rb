# frozen_string_literal: true

require_relative "../../days/day23"

RSpec.describe "Days::Day23" do
  let(:day_runner) { Days::Day23.new(puzzle_input) }

  let(:puzzle_input) do
    <<~INPUT
      kh-tc
      qp-kh
      de-cg
      ka-co
      yn-aq
      qp-ub
      cg-tb
      vc-aq
      tb-ka
      wh-tc
      yn-cg
      kh-ub
      ta-co
      de-co
      tc-td
      tb-wq
      wh-td
      ta-ka
      td-qp
      aq-cg
      wq-ub
      ub-vc
      de-ta
      wq-aq
      wq-vc
      wh-yn
      ka-de
      kh-ta
      co-tc
      wh-qp
      tb-vc
      td-yn
    INPUT
  end

  describe "#part_a" do
    it "returns the correct value for part A" do
      expect(day_runner.part_a).to eq "7"
    end
  end

  describe "#part_b" do
    it "returns the correct value for part B" do
      expect(day_runner.part_b).to eq "co,de,ka,ta"
    end
  end
end
