# frozen_string_literal: true

require_relative "../../../lib/aoc/dijkstra"
require_relative "../../../lib/aoc/edge"

module AOC
  RSpec.describe Dijkstra do
    let(:vertices) do
      [1, 2, 3, 4, 5, 6]
    end
    let(:edges) do
      [
        Edge.new(1, 2, weight: 7),   Edge.new(2, 1, weight: 7),
        Edge.new(1, 3, weight: 9),   Edge.new(3, 1, weight: 9),
        Edge.new(1, 6, weight: 14),  Edge.new(6, 1, weight: 14),
        Edge.new(2, 3, weight: 10),  Edge.new(3, 2, weight: 10),
        Edge.new(2, 4, weight: 15),  Edge.new(4, 2, weight: 15),
        Edge.new(3, 4, weight: 11),  Edge.new(4, 3, weight: 11),
        Edge.new(3, 6, weight: 2),   Edge.new(6, 3, weight: 2),
        Edge.new(4, 5, weight: 1),   Edge.new(5, 4, weight: 1),
        Edge.new(5, 6, weight: 10),  Edge.new(6, 5, weight: 10),
      ]
    end

    subject(:dijkstra) { Dijkstra.new(vertices, edges) }

    describe "#generate_shortest_paths" do
      let(:result) { dijkstra.generate_shortest_paths(1) }

      describe "distances" do
        it "is expected to show the distances from the source to each vertex" do
          expect(result.distances).to eq({ 1 => 0, 2 => 7, 3 => 9, 4 => 20, 5 => 21, 6 => 11 })
        end
      end

      describe "parents" do
        it "is expected to show the parent paths from each vertex back toward the source" do
          expect(result.parents).to eq(
            { 2 => 1, 3 => 1, 4 => 3, 5 => 4, 6 => 3 },
          ).or eq(
            { 2 => 1, 3 => 1, 4 => 3, 5 => 6, 6 => 3 },
          )
        end
      end
    end

    describe "#path(1,...)" do
      let(:parents) { { 2 => 1, 3 => 1, 4 => 3, 5 => 4, 6 => 3 } }

      it "creates a path from source to target using parents" do
        expect(dijkstra.path(1, 5, parents)).to eq([1, 3, 4, 5])
        expect(dijkstra.path(1, 6, parents)).to eq([1, 3, 6])
      end
    end

    describe "#generate_shortest_multipaths" do
      let(:result) { dijkstra.generate_shortest_multipaths(1) }

      describe "distances" do
        it "is expected to show the distances from the source to each vertex" do
          expect(result.distances).to eq({ 1 => 0, 2 => 7, 3 => 9, 4 => 20, 5 => 21, 6 => 11 })
        end
      end

      describe "parents" do
        it "is expected to show all the parent paths from each vertex back toward the source" do
          expect(result.parents).to eq({ 2 => [1], 3 => [1], 6 => [3], 4 => [3], 5 => [6, 4] })
        end
      end
    end

    describe "#multipath" do
      context "with a trivial example" do
        let(:parents) { { 2 => [1], 3 => [2, 1], 4 => [3], 6 => [2] } }

        it "creates all paths from source to target using parents" do
          expect(
            {
              a: dijkstra.multipath(1, 2, parents),
              b: dijkstra.multipath(1, 3, parents),
              c: dijkstra.multipath(1, 6, parents),
              d: dijkstra.multipath(1, 4, parents),
            },
          ).to eq(
            {
              a: [
                [1, 2],
              ],
              b: [
                [1, 2, 3],
                [1, 3],
              ],
              c: [
                [1, 2, 6],
              ],
              d: [
                [1, 2, 3, 4],
                [1, 3, 4],
              ],
            },
          )
        end
      end

      context "with the main example" do
        let(:parents) { { 2 => [1], 3 => [1], 6 => [3], 4 => [3], 5 => [6, 4] } }

        it "creates all paths from source to target using parents" do
          expect(dijkstra.multipath(1, 5, parents)).to eq(
            [
              [1, 3, 6, 5],
              [1, 3, 4, 5],
            ],
          )
        end
      end
    end
  end
end
