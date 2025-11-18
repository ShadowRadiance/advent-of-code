# frozen_string_literal: true

require_relative "heap"

module AOC
  class PriorityQueue
    def initialize(priority_only: false)
      @heap = Heap.new
      @element_class = priority_only ? PriorityOnlyElement : Element
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
      @heap.add(@element_class.new(value, priority: priority))
    end

    def pop
      @heap.extract.value
    end

    def reprioritize(value, new_priority)
      @heap.rerank(@element_class.new(value, priority: new_priority))
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

    class PriorityOnlyElement < Element
      def <=>(other)
        @priority <=> other.priority
      end
    end

    private_constant :Element
    private_constant :PriorityOnlyElement
  end
end
