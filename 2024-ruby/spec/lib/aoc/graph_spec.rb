# frozen_string_literal: true

require_relative "../../../lib/aoc/graph"

module AOC
  RSpec.describe "Graph" do
    subject { Graph.new(vertices, edges) }
    let(:vertices) { [1, 2, 3, 4] }
    let(:edges) do
      [Edge.new(1, 2),
       Edge.new(2, 3),
       Edge.new(3, 4),]
    end

    it { is_expected.to be_a(Graph) }
  end
end
