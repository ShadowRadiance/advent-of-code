# frozen_string_literal: true

require_relative "../../days/day09"

RSpec.describe "Days::Day09" do
  describe "day_runner" do
    let(:day_runner) { Days::Day09.new(puzzle_input) }

    let(:puzzle_input) { "2333133121414131402" }

    describe "#part_a" do
      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "1928"
      end
    end

    describe "#part_b" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "2858"
      end
    end
  end

  describe "DiskMap" do
    let(:strategy) { Days::Day09::MoveFileBlocks }
    let(:disk_map) { Days::Day09::DiskMap.new("2333133121414131402", strategy: strategy) }

    describe "initial state" do
      it "parses the representation" do
        expect(disk_map.blocks.join).to eq("00...111...2...333.44.5555.6666.777.888899")
      end
    end

    describe ".compact" do
      it "compacts the map" do
        disk_map.compact
        expect(disk_map.blocks.join).to eq("0099811188827773336446555566..............")
      end

      context "when in part b" do # rubocop:disable RSpec/NestedGroups
        let(:strategy) { Days::Day09::MoveWholeFiles }

        it "compacts the map differently" do
          disk_map.compact
          expect(disk_map.blocks.join).to eq("00992111777.44.333....5555.6666.....8888..")
        end
      end
    end
  end
end
