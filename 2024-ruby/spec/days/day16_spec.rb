# frozen_string_literal: true

require_relative "../../days/day16"

RSpec.describe "Days::Day16" do
  let(:day_runner) { Days::Day16.new(puzzle_input) }

  let(:example_one) do
    <<~INPUT
      ###############
      #.......#....E#
      #.#.###.#.###.#
      #.....#.#...#.#
      #.###.#####.#.#
      #.#.#.......#.#
      #.#.#####.###.#
      #...........#.#
      ###.#.#####.#.#
      #...#.....#.#.#
      #.#.#.###.#.#.#
      #.....#...#.#.#
      #.###.#.#.#.#.#
      #S..#.....#...#
      ###############
    INPUT
  end

  let(:example_two) do
    <<~INPUT
      #################
      #...#...#...#..E#
      #.#.#.#.#.#.#.#.#
      #.#.#.#...#...#.#
      #.#.#.#.###.#.#.#
      #...#.#.#.....#.#
      #.#.#.#.#.#####.#
      #.#...#.#.#.....#
      #.#.#####.#.###.#
      #.#.#.......#...#
      #.#.###.#####.###
      #.#.#...#.....#.#
      #.#.#.#####.###.#
      #.#.#.........#.#
      #.#.#.#########.#
      #S#.............#
      #################
    INPUT
  end

  let(:tiny_example) do
    <<~INPUT
      #####
      #..E#
      #.#.#
      #S#.#
      #####
    INPUT
  end

  describe "#part_a" do
    context "with tiny example" do
      let(:puzzle_input) { tiny_example }

      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "2004"
      end
    end

    context "with example one" do
      let(:puzzle_input) { example_one }

      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "7036"
      end
    end

    context "with example two" do
      let(:puzzle_input) { example_two }

      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "11048"
      end
    end
  end

  describe "#part_b" do
    context "with tiny example" do
      let(:puzzle_input) { tiny_example }

      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "5"
      end
    end

    fcontext "with example one" do
      let(:puzzle_input) { example_one }

      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "45"
      end
    end

    context "with example two" do
      let(:puzzle_input) { example_two }

      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "64"
      end
    end
  end
end
