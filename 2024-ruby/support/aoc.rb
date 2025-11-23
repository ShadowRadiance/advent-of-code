# frozen_string_literal: true

module Support
  class AOC
    attr_reader :base_path

    # TODO: This should be injected from a config file
    SLOW_LIST = %w[
      6b
      7b
      9b
      14b
      16b
      22b
    ].freeze

    def initialize(base_path:)
      @base_path = base_path
    end

    def run_all
      (1..25).map { |day| run_day(day) }
    end

    def run_day(day)
      {
        part_a: run_part(day, "a"),
        part_b: run_part(day, "b"),
      }
    end

    def run_part(day, part)
      return "SLOW" if SLOW_LIST.include?("#{day}#{part}") && ENV["FORCE_SLOW"] != "1"

      require_day_runner(day)
      klass_name = class_name(day)
      if Object.const_defined?(klass_name)
        klass = Object.const_get(klass_name)
        day_runner = klass.new(input_data(day))
        day_runner.public_send("part_#{part}")
      else
        "NO RUNNER FOR DAY #{padded(day)} PART #{part.upcase}"
      end
    end

    def data_filename(day) = "#{@base_path}/data/day#{padded(day)}.txt"
    def class_name(day)    = "Days::Day#{padded(day)}"
    def padded(day)        = day.to_s.rjust(2, "0")

    private

    def require_day_runner(day)
      day_runner_definition_file = File.join(base_path, "days", "day#{padded(day)}.rb")
      require_relative day_runner_definition_file if File.exist?(day_runner_definition_file)
    end

    def input_data(day)
      File.read(data_filename(day))
    end
  end
end
