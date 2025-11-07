# frozen_string_literal: true

require_relative "../../../lib/aoc/priority_queue"

module AOC
  RSpec.describe PriorityQueue do
    subject(:queue) { described_class.new }

    context "when the queue is new" do
      it { is_expected.to be_empty }
      it { is_expected.to have_attributes(size: 0) }
      it { is_expected.to have_attributes(to_a: []) }
    end

    context "when some items have been added" do
      context "without priorities" do
        before do
          queue.push "Bob"
          queue.push "Charlie"
          queue.push "Annie"
        end

        it { is_expected.not_to be_empty }
        it { is_expected.to have_attributes(size: 3) }

        it "is expected to pop them smallest first" do
          expect(
            [queue.pop, queue.pop, queue.pop],
          ).to eq(
            %w[Annie Bob Charlie],
          )
        end
      end

      context "with priorities" do
        before do
          queue.push "Annie", priority: 3
          queue.push "Bob", priority: 1
          queue.push "Charlie", priority: 2
        end

        it { is_expected.not_to be_empty }
        it { is_expected.to have_attributes(size: 3) }

        it "is expected to pop them smallest priority first" do
          expect(
            [queue.pop, queue.pop, queue.pop],
          ).to eq(
            %w[Bob Charlie Annie],
          )
        end
      end
    end
  end
end
