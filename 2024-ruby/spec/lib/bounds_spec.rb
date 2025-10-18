# frozen_string_literal: true

require_relative "../../lib/bounds"

RSpec.describe "Bounds" do
  let(:bounds) { Bounds.new(min_x: -1, max_x: 2, min_y: -3, max_y: 4) }

  it "returns true for x,y values within the boundaries" do
    (-1..2).each do |x|
      (-3..4).each do |y|
        expect(bounds.cover?(x: x, y: y)).to be(true)
      end
    end
  end

  it "returns false for x,y values outside the boundaries" do
    [-2, 3].each do |x|
      [-4, 5].each do |y|
        expect(bounds.cover?(x: x, y: y)).to be(false)
      end
    end
  end
end
