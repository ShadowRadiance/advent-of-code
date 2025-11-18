# frozen_string_literal: true

require_relative "../../../lib/aoc/location"
require_relative "../../../lib/aoc/bounds"

module AOC
  RSpec.describe "Location" do
    let(:bounds) do
      Bounds.new(
        min_x: -1,
        max_x: +2,
        min_y: -3,
        max_y: +4,
      )
    end

    describe ".in_bounds?" do
      it "returns true for locations that are within bounds" do
        (-1..2).each do |x|
          (-3..4).each do |y|
            expect(Location.new(x: x, y: y).in_bounds?(bounds)).to be(true)
          end
        end
      end

      it "returns false for locations that are out of bounds" do
        [-2, 3].each do |x|
          [-4, 5].each do |y|
            expect(Location.new(x: x, y: y).in_bounds?(bounds)).to be(false)
          end
        end
      end
    end

    describe "manhattan_distance" do
      it "returns the manhattan distance to the other location" do
        location_a = Location.new(x: 5, y: 5)
        location_b = Location.new(x: 2, y: 3)
        expect(location_a.manhattan_distance(location_b)).to eq(5)
      end
    end
  end
end
