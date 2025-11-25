# frozen_string_literal: true

module Days
  class Day23
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    Edge = Data.define(:lft, :rgt)

    # @return [Hash<String, Array<String>]
    # @example Return Value
    #   {
    #     "aq" => ["yn", "vc", "cg", "wq"],
    #     "cg" => ["de", "tb", "yn", "aq"],
    #     "co" => ["ka", "ta", "de", "tc"],
    #     "de" => ["cg", "co", "ta", "ka"],
    #     "ka" => ["co", "tb", "ta", "de"],
    #     "kh" => ["tc", "qp", "ub", "ta"],
    #     "qp" => ["kh", "ub", "td", "wh"],
    #     "ta" => ["co", "ka", "de", "kh"],
    #     "tb" => ["cg", "ka", "wq", "vc"],
    #     "tc" => ["kh", "wh", "td", "co"],
    #     "td" => ["tc", "wh", "qp", "yn"],
    #     "ub" => ["qp", "kh", "wq", "vc"],
    #     "vc" => ["aq", "ub", "wq", "tb"],
    #     "wh" => ["tc", "td", "yn", "qp"],
    #     "wq" => ["tb", "ub", "aq", "vc"],
    #     "yn" => ["aq", "cg", "wh", "td"],
    #   }
    def parse_input
      edges = Hash.new { |hash, key| hash[key] = [] }
      @puzzle_input.lines(chomp: true).each do |line|
        l, r = line.split("-")
        edges[l] << r
        edges[r] << l
      end
      edges
    end

    def part_a
      count_triplets(edges: parse_input, including: /^t.$/)
      # 1098 in 0.05s
    end

    def part_b
      "PENDING_B"
    end

    def count_triplets(edges:, including:)
      starts = edges.keys.select { |k| k =~ including }
      triplets = starts.flat_map { |start| sorted_triplets_from(start, edges) }.uniq
      triplets.size.to_s
    end

    def sorted_triplets_from(first, edges)
      # a triplet is a set of computers such that there is an edge from
      #  first <-> second
      #  second <-> third
      #  first <-> third
      # we can find all the potential seconds easily enough from "edges[first]"
      triplets = []
      seconds = edges[first]
      # thirds are the "edges[second]" where "edges[third]" includes "first"
      seconds.each do |second|
        thirds = edges[second].select { |third| third != first && edges[third].include?(first) }
        next if thirds.empty?

        thirds.each do |third|
          triplets << [first, second, third]
        end
      end
      triplets.map(&:sort).uniq
    end
  end
end
