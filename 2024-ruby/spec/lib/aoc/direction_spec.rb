# frozen_string_literal: true

require_relative "../../../lib/aoc/direction"
module AOC
  RSpec.describe "Direction" do
    describe "Direction.compass_directions" do
      it "returns the eight compass directions" do
        expect(Direction.compass_directions).to eq(
          {
            north: Direction.new(x: +0, y: -1),
            north_east: Direction.new(x: +1, y: -1),
            east: Direction.new(x: +1, y: +0),
            south_east: Direction.new(x: +1, y: +1),
            south: Direction.new(x: +0, y: +1),
            south_west: Direction.new(x: -1, y: +1),
            west: Direction.new(x: -1, y: +0),
            north_west: Direction.new(x: -1, y: -1),
          },
        )
      end
    end

    describe ".rotate90right" do
      it "rotates the direction clockwise" do
        [
          { initial: :north, rotated: :east },
          { initial: :east, rotated: :south },
          { initial: :south, rotated: :west },
          { initial: :west, rotated: :north },
        ].each do |h|
          initial = Direction.compass_directions[h[:initial]]
          rotated = Direction.compass_directions[h[:rotated]]
          expect(initial.rotate90right).to eq(rotated)
        end
      end
    end

    describe ".rotate90left" do
      it "rotates the direction anticlockwise" do
        [
          { initial: :north, rotated: :west },
          { initial: :west, rotated: :south },
          { initial: :south, rotated: :east },
          { initial: :east, rotated: :north },
        ].each do |h|
          initial = Direction.compass_directions[h[:initial]]
          rotated = Direction.compass_directions[h[:rotated]]
          expect(initial.rotate90left).to eq(rotated)
        end
      end
    end
  end
end
