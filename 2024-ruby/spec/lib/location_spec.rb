# frozen_string_literal: true

require_relative "../../lib/location"
require_relative "../../lib/bounds"

RSpec.describe "Location" do
  let(:bounds) do
    Bounds.new(
      min_x: -1,
      max_x: +2,
      min_y: -3,
      max_y: +4,
    )
  end

  describe ".in_bounds" do
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
end
