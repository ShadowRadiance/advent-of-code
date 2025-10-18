# frozen_string_literal: true

require_relative "../../lib/vector"

RSpec.describe "Vector" do
  describe ".+" do
    it "adds two vectors" do
      a = Vector.new(x: 1, y: 2)
      b = Vector.new(x: 3, y: 4)
      expect(a + b).to eq(Vector.new(4, 6))
    end

    it "does not add a vector to something else" do
      a = Vector.new(x: 1, y: 2)
      [7, "hello", 3.5].each do |val|
        expect { a + val }.to raise_error(TypeError)
      end
    end
  end

  describe ".*" do
    it "performs scalar multiplication with numerics" do
      v = Vector.new(x: 1, y: 2)

      expect(
        [
          v * 2,
          v * 0,
          v * 2.5,
        ],
      ).to eq(
        [
          Vector.new(2, 4),
          Vector.new(0, 0),
          Vector.new(2.5, 5),
        ],
      )
    end

    it "does not multiply a vector to something else" do
      a = Vector.new(x: 1, y: 2)
      ["hello", Vector.new(1, 3)].each do |val|
        expect { a * val }.to raise_error(TypeError)
      end
    end
  end
end
