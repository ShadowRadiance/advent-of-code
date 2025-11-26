# frozen_string_literal: true

require_relative "bron_kerbosch"
require_relative "dijkstra"
require_relative "priority_queue"

module AOC
  class Graph
    # @param [Set<String|Integer>, Array<String|Integer>] vertices
    # @param [Array<Edge>] edges
    def initialize(vertices, edges)
      @vertices = Set.new(vertices)
      @edges = edges
      @out_edges_by_source = edges.group_by(&:source)
    end

    # @param [String] vertex
    # @return self
    def eliminate_vertex(vertex)
      @vertices.delete(vertex)
      @edges.delete_if { |e| e.source == vertex || e.target == vertex }
      @out_edges_by_source.delete(vertex)
      @out_edges_by_source.each_value do |edges|
        edges.delete_if { |e| e.source == vertex || e.target == vertex }
      end
      self
    end

    def reachable?(source, target) # rubocop:disable Metrics/MethodLength
      visited = Set.new
      queue = AOC::PriorityQueue.new(priority_only: true)
      queue.push(source)
      until queue.empty?
        vertex = queue.pop
        next if visited.include?(vertex)
        return true if vertex == target

        @out_edges_by_source[vertex].each { |v| queue.push(v.target) }
        visited << vertex
      end
      false
    end

    def neighbours(vertex)
      @out_edges_by_source[vertex].map(&:target).uniq
    end

    # @param [String] source
    # @param [String] target
    # @return [Numeric, nil]
    def dijkstra_shortest_path_length(source, target)
      dijkstra = AOC::Dijkstra.new(@vertices, @edges)
      result = dijkstra.generate_shortest_paths(source)
      distance = result.distances[target]
      return nil if distance == Float::INFINITY

      distance
    end

    # @param [String] source
    # @param [String] target
    # @return [Array<String>, nil]
    def dijkstra_shortest_path(source, target)
      dijkstra = AOC::Dijkstra.new(@vertices, @edges)
      result = dijkstra.generate_shortest_paths(source)
      dijkstra.path(source, target, result.parents)
    end

    # @param [String] source
    # @param [String] target
    # @return [Array(String, Integer)], Array(nil,nil)]
    def dijkstra_shortest_path_with_length(source, target)
      dijkstra = AOC::Dijkstra.new(@vertices, @edges)
      result = dijkstra.generate_shortest_paths(source)
      distance = result.distances[target]
      return [nil, nil] if distance == Float::INFINITY

      [
        dijkstra.path(source, target, result.parents),
        distance,
      ]
    end

    def maximal_cliques
      bk = BronKerbosch.new(potential: @vertices.dup, graph: self)
      bk.evaluate
    end
  end
end
