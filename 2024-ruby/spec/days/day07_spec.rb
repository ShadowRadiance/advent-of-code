# frozen_string_literal: true

require_relative "../../days/day07"

RSpec.describe "Days::Day07" do
  let(:day_runner) { Days::Day07.new(puzzle_input) }

  let(:puzzle_input) { "" }

  describe "#part_a" do
    context "with the sample data" do
      it "returns the correct value for part A" do
        expect(day_runner.part_a).to eq "PENDING-A"
      end
    end
  end

  describe "#part_b" do
    context "with the sample data" do
      it "returns the correct value for part B" do
        expect(day_runner.part_b).to eq "PENDING-B"
      end
    end
  end
end
