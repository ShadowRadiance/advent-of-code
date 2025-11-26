# frozen_string_literal: true

class BronKerbosch
  def initialize(potential:, graph:)
    @potential = potential
    @maximal_cliques = [] # Array<Set>
    @graph = graph
  end

  def evaluate
    recursive(
      results: Set.new,
      potentials: @potential,
      excluded: Set.new,
    )
    @maximal_cliques
  end

  private

  def recursive(results:, potentials:, excluded:) # rubocop:disable Metrics/MethodLength
    if potentials.empty? && excluded.empty?
      @maximal_cliques << results
    else
      p_a = potentials.to_a
      p_a.each do |potential|
        neighbours = @graph.neighbours(potential)
        recursive(
          results: results.union([potential]),
          potentials: potentials.intersection(neighbours),
          excluded: excluded.intersection(neighbours),
        )
        # move potential from potentials to excluded
        potentials = potentials.difference([potential])
        excluded = excluded.union([potential])
      end
    end
  end
end
