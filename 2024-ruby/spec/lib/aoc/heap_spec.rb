# frozen_string_literal: true

require_relative "../../../lib/aoc/heap"

module AOC
  RSpec.describe "Heap" do
    context "with an empty heap" do
      subject(:heap) { Heap.new }

      it { is_expected.to be_empty }

      context "when one item has been added" do
        before do
          heap.add(54)
        end

        it { is_expected.not_to be_empty }
        it { is_expected.to have_attributes(size: 1) }
        it { is_expected.to have_attributes(to_a: [54]) }
      end

      context "when four items have been added" do
        before do
          heap.add(54)
          heap.add(2)
          heap.add(12)
          heap.add(1)
        end

        it { is_expected.not_to be_empty }
        it { is_expected.to have_attributes(size: 4) }

        it "is expected to extract them smallest first" do
          expect(
            [heap.extract, heap.extract, heap.extract, heap.extract],
          ).to eq(
            [1, 2, 12, 54],
          )
        end

        context "when the top item has been removed" do
          before do
            @top = heap.extract
          end

          it "extracted the lowest value" do
            expect(@top).to eq(1)
          end

          it { is_expected.not_to be_empty }
          it { is_expected.to have_attributes(size: 3) }

          it "is expected to extract them smallest first" do
            expect(
              [heap.extract, heap.extract, heap.extract],
            ).to eq(
              [2, 12, 54],
            )
          end
        end
      end
    end
  end
end
