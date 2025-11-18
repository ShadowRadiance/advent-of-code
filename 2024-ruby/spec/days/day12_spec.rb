# frozen_string_literal: true

require_relative "../../days/day12"

RSpec.describe "Days::Day12" do
  let(:day_runner) { Days::Day12.new(puzzle_input) }

  context "with input ABCDE" do
    let(:puzzle_input) do
      <<~INPUT
        AAAA
        BBCD
        BBCC
        EEEC
      INPUT
    end
    let(:price) { 140 }
    let(:discounted) { 80 }

    describe "part_a" do
      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq(price.to_s)
      end
    end

    describe "#part_b" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq(discounted.to_s)
      end
    end
  end

  context "with input OXOXO" do
    let(:puzzle_input) do
      <<~INPUT
        OOOOO
        OXOXO
        OOOOO
        OXOXO
        OOOOO
      INPUT
    end
    let(:price) { 772 }
    let(:discounted) { 436 }

    describe "part_a" do
      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq(price.to_s)
      end
    end

    describe "#part_b" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq(discounted.to_s)
      end
    end
  end

  context "with input MISJE" do
    let(:puzzle_input) do
      <<~INPUT
        RRRRIICCFF
        RRRRIICCCF
        VVRRRCCFFF
        VVRCCCJFFF
        VVVVCJJCFE
        VVIVCCJJEE
        VVIIICJJEE
        MIIIIIJJEE
        MIIISIJEEE
        MMMISSJEEE
      INPUT
    end
    let(:price) { 1930 }
    let(:discounted) { 1206 }

    describe "part_a" do
      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq(price.to_s)
      end
    end

    describe "#part_b" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq(discounted.to_s)
      end
    end
  end

  context "with input EEEEE" do
    let(:puzzle_input) do
      <<~INPUT
        EEEEE
        EXXXX
        EEEEE
        EXXXX
        EEEEE
      INPUT
    end
    let(:discounted) { 236 }

    describe "#part_b" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq(discounted.to_s)
      end
    end
  end

  context "with input AAABBA" do
    let(:puzzle_input) do
      <<~INPUT
        AAAAAA
        AAABBA
        AAABBA
        ABBAAA
        ABBAAA
        AAAAAA
      INPUT
    end
    let(:discounted) { 368 }

    describe "#part_b" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq(discounted.to_s)
      end
    end
  end
end
