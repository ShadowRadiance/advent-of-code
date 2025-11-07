# frozen_string_literal: true

require_relative "heap"

module AOC
  class PriorityQueue
    def initialize
      @heap = Heap.new
    end

    def empty?
      @heap.empty?
    end

    def size
      @heap.size
    end

    def to_a
      @heap.to_a.map(&:value)
    end

    def push(value, priority: 0)
      @heap.add(Element.new(value, priority: priority))
    end

    def pop
      @heap.extract.value
    end

    def reprioritize(value, new_priority)
      @heap.rerank(Element.new(value, priority: new_priority))
    end

    class Element
      include Comparable

      attr_accessor :value, :priority

      def initialize(value, priority: 0)
        @value = value
        @priority = priority
      end

      def ==(other)
        other.is_a?(Element) && @value == other.value
      end

      def <=>(other)
        return value <=> other.value if @priority == other.priority

        @priority <=> other.priority
      end
    end

    private_constant :Element
  end
end
