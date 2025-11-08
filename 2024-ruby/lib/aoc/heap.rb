# frozen_string_literal: true

# imported from my Heap for 2021's Day 15

module AOC
  class Heap
    def initialize
      @rep = [nil]
    end

    def empty?
      size.zero?
    end

    def size
      @rep.size - 1
    end

    def to_a
      @rep.slice(1..-1)
    end

    def add(element)
      index = @rep.size
      @rep[index] = element

      bubble_up(index)
    end

    def bubble_up(index)
      pindex = parent_index(index)
      return if pindex < 1 # at top
      return if @rep[index] >= @rep[pindex]

      swap_indices(index, pindex)
      bubble_up(pindex)
    end

    def bubble_down(index)
      lindex = left_index(index)
      return if lindex > size # off the end no children

      rindex = right_index(index)
      cindex = @rep[rindex] && @rep[rindex] < @rep[lindex] ? rindex : lindex
      return if @rep[index] <= @rep[cindex]

      swap_indices(index, cindex)
      bubble_down(cindex)
    end

    def extract
      swap_indices(1, size)
      min = @rep.pop
      bubble_down(1)
      min
    end

    def include?(object)
      @rep.include?(object)
    end

    def rerank(object)
      index = @rep.index(object)
      remove_at(index)
      add(object)
    end

    def index(object)
      @rep.index(object)
    end

    def remove_at(index)
      # if it is already the last one, just pop it
      if index == size
        @rep.pop
        return
      end

      swap_indices(index, size)
      @rep.pop
      heapify(index)
    end

    def heapify(index)
      pindex = parent_index(index)
      if pindex >= 1 && @rep[index] < @rep[pindex]
        bubble_up(index)
      else
        bubble_down(index)
      end
    end

    private

    def parent_index(index)
      index / 2
    end

    def left_index(index)
      2 * index
    end

    def right_index(index)
      (2 * index) + 1
    end

    def swap_indices(a, b) # rubocop:disable Naming/MethodParameterName
      @rep[a], @rep[b] = @rep[b], @rep[a]
    end
  end
end
