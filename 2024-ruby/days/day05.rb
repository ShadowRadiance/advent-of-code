# frozen_string_literal: true

module Days
  class Day05
    def initialize(puzzle_input)
      @puzzle_input = puzzle_input
    end

    def part_a
      # score the correctly ordered updates

      updates = parse_input[:updates]
      rules = parse_input[:rules]

      raise "PAGE PRINTED TWICE IN AN UPDATE" if updates.any? do |update|
        update.uniq.length != update.length
      end

      updates.filter { update_correctly_ordered?(it, rules) }
             .map { update_score(it) }
             .sum.to_s
    end

    def part_b
      # fix and score the incorrectly ordered updates

      updates = parse_input[:updates]
      rules = parse_input[:rules]

      updates.filter { !update_correctly_ordered?(it, rules) }
             .map { fix_update_ordering(it, rules) }
             .map { update_score(it) }
             .sum.to_s
    end

    def update_score(update)
      middle_index = (update.length - 1) / 2
      update[middle_index]
    end

    def update_correctly_ordered?(update, rules)
      rules.each do |rule|
        next unless rule_applies?(update, rule)

        return false if rule_broken?(update, rule)
      end

      true
    end

    def rule_applies?(update, rule)
      [rule[:earlier], rule[:later]].all? { update.include?(it) }
    end

    def rule_broken?(update, rule)
      earlier_index = update.find_index(rule[:earlier])
      later_index = update.find_index(rule[:later])

      earlier_index > later_index
    end

    def fix_update_ordering(update, rules)
      applicable_rules = rules.filter { rule_applies?(update, it) }

      ruleset = {}
      applicable_rules.each do |rule|
        ruleset[rule[:earlier]] ||= []
        ruleset[rule[:earlier]] << rule[:later]
      end

      update.sort do |a, b|
        ruleset[a]&.include?(b) ? -1 : 1
      end
    end

    # ---

    def parse_input
      result = {
        rules: [],
        updates: [],
      }
      parser = RuleParser.new
      puzzle_input.lines(chomp: true).each do |line|
        if line.empty?
          parser = UpdateParser.new
          next
        end
        result[parser.key] << parser.parse(line)
      end
      result
    end

    class RuleParser
      def parse(line)
        earlier, later = line.split("|")
        { earlier: earlier.to_i, later: later.to_i }
      end

      def key = :rules
    end

    class UpdateParser
      def parse(line)
        line.split(",").map(&:to_i)
      end

      def key = :updates
    end

    private

    attr_reader :puzzle_input
  end
end
