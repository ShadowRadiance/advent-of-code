# frozen_string_literal: true

module AOC
  class Edge
    attr_reader :source, :target, :weight

    def initialize(source, target, weight: 1)
      @source = source
      @target = target
      @weight = weight
    end
  end
end
