# frozen_string_literal: true

require_relative "priority_queue"

module AOC
  class Dijkstra
    Result = Data.define(:distances, :parents)

    def initialize(vertices, edges)
      @vertices = vertices
      @edges = edges
    end

    # computes the shortest distance from starting node
    # to each other node remembering the path that
    # cause that shortest distance
    def generate_shortest_paths(source)
      distances = Hash.new { Float::INFINITY }
      distances[source] = 0

      parents = Hash.new { nil }

      queue = PriorityQueue.new
      @vertices.each do |vertex|
        queue.push(
          vertex,
          priority: vertex == source ? 0 : Float::INFINITY,
        )
      end

      until queue.empty?
        vertex_u = queue.pop
        edges_of(vertex_u).each do |edge|
          new_distance = distances[vertex_u] + edge.weight
          vertex_v = edge.target
          next unless new_distance < distances[vertex_v]

          parents[vertex_v] = vertex_u
          distances[vertex_v] = new_distance
          queue.reprioritize(vertex_v, new_distance)
        end
      end

      Result.new(distances, parents)
    end

    def path(source, target, parents)
      return [source] if target == source

      path(source, parents[target], parents) + [target]
    end

    private

    def edges_of(vertex)
      @edges.filter { |edge| edge.source == vertex }
    end
  end
end
