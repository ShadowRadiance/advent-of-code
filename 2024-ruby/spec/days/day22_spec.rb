# frozen_string_literal: true

require_relative "../../days/day22"

RSpec.describe "Days::Day22" do
  describe "Secret Number Generator" do
    let(:sng) { Days::Day22::SecretNumberGenerator.new(base: base) }

    context "with a base of 123" do
      let(:base) { 123 }

      it "yields the expected numbers" do
        results = (1..10).map { sng.generate_next }
        expect(results).to contain_exactly(
          15_887_950,
          16_495_136,
          527_345,
          704_524,
          1_553_684,
          12_683_156,
          11_100_544,
          12_249_484,
          7_753_432,
          5_908_254,
        )
      end
    end

    {
      1 => 8_685_429,
      10 => 4_700_978,
      100 => 15_273_692,
      2024 => 8_667_524,
    }.each do |k, v|
      context "with a base of #{k}" do
        let(:base) { k }

        it "yields #{v} as the 2000th number" do
          expect(sng.generate_next_n(2000)).to eq(v)
        end
      end
    end
  end

  describe "Main Problem" do
    let(:day_runner) { Days::Day22.new(puzzle_input) }

    describe "#part_a" do
      let(:puzzle_input) do
        <<~INPUT
          1
          10
          100
          2024
        INPUT
      end

      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "37327623"
      end
    end

    describe "#part_b" do
      let(:puzzle_input) do
        <<~INPUT
          1
          2
          3
          2024
        INPUT
      end

      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "23"
      end
    end
  end
end
