# frozen_string_literal: true

require_relative "../../days/day15"

RSpec.describe "Days::Day15" do
  let(:day_runner) { Days::Day15.new(puzzle_input) }

  let(:larger_example) do
    <<~INPUT
      ##########
      #..O..O.O#
      #......O.#
      #.OO..O.O#
      #..O@..O.#
      #O#..O...#
      #O..O..O.#
      #.OO.O.OO#
      #....O...#
      ##########

      <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
      vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
      ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
      <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
      ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
      ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
      >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
      <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
      ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
      v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
    INPUT
  end

  let(:smaller_example) do
    <<~INPUT
      ########
      #..O.O.#
      ##@.O..#
      #...O..#
      #.#.O..#
      #...O..#
      #......#
      ########

      <^^>>>vv<v>>v<<
    INPUT
  end

  let(:smaller_example_for_part_b) do
    <<~INPUT
      #######
      #...#.#
      #.....#
      #..OO@#
      #..O..#
      #.....#
      #######

      <vv<<^^<<^^
    INPUT
  end

  describe "#part_a" do
    context "with larger example" do
      let(:puzzle_input) { larger_example }

      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "10092"
      end
    end

    context "with smaller example" do
      let(:puzzle_input) { smaller_example }

      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "2028"
      end
    end
  end

  describe "#part_b" do
    context "with larger example" do
      let(:puzzle_input) { larger_example }

      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "9021"
      end
    end

    context "with smaller example" do
      let(:puzzle_input) { smaller_example_for_part_b }

      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "618"
      end
    end
  end
end
