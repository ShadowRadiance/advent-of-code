# frozen_string_literal: true

require "open-uri"

module Support
  class DayGenerator
    def initialize(aoc:, year:, day:)
      @aoc = aoc

      raise "Missing template" unless File.exist?(day_template_path)
      raise "Missing test template" unless File.exist?(test_template_path)

      @year = year
      @day = day
    end

    def generate
      raise "Invalid year" unless (2015..).cover?(@year)

      generate_day
      generate_test
      generate_data
    end

    private

    def generate_day
      return if overwrites?(day_path)

      File.write(day_path, File.read(day_template_path).gsub("00", padded_day))
    end

    def generate_test
      return if overwrites?(test_day_path)

      File.write(test_day_path, File.read(test_template_path).gsub("00", padded_day))
    end

    def generate_data
      return if overwrites?(datum_path)
      return if missing_cookie?

      begin
        session_cookie = File.read(cookie_path)
        headers = { "Cookie" => "session=#{session_cookie}" }
        puzzle_input = URI.parse(puzzle_input_url).open(headers, &:read)
        File.write(datum_path, puzzle_input)
      rescue OpenURI::HTTPError => e
        puts "Got #{e.message}. Is your session cookie up to date in #{cookie_path}?"
      end
    end

    def overwrites?(path)
      return false unless File.exist?(path)

      puts "Not overwriting existing file #{path}"
      true
    end

    def missing_cookie?
      return false if File.exist?(cookie_path)

      puts "Not auto-downloading from AOC. You need to specify your AoC session cookie in #{cookie_path}"
      true
    end

    def padded_day         = @aoc.padded(@day)
    def cookie_path        = "#{@aoc.base_path}/aoc_cookie"
    def day_template_path  = "#{@aoc.base_path}/templates/day00.rb.template"
    def test_template_path = "#{@aoc.base_path}/templates/day00_spec.rb.template"
    def day_path           = "#{@aoc.base_path}/days/day#{padded_day}.rb"
    def test_day_path      = "#{@aoc.base_path}/spec/days/day#{padded_day}_spec.rb"
    def datum_path         = @aoc.data_filename(@day)
    def puzzle_input_url   = "https://adventofcode.com/#{@year}/day/#{@day}/input"
  end
end
