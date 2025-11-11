#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require_relative '../lib/tyco'

SUITE_ROOT = File.expand_path('../../tyco-test-suite', __dir__)
INPUT_DIR = File.join(SUITE_ROOT, 'inputs')
EXPECTED_DIR = File.join(SUITE_ROOT, 'expected')

tests = Dir.glob(File.join(INPUT_DIR, '*.tyco')).sort.select do |input|
  File.exist?(File.join(EXPECTED_DIR, "#{File.basename(input, '.tyco')}.json"))
end

puts "1..#{tests.length}"
failed = false
tests.each_with_index do |input, index|
  expected_path = File.join(EXPECTED_DIR, "#{File.basename(input, '.tyco')}.json")
  begin
    actual = Tyco.load_file(input)
    expected_data = JSON.parse(File.read(expected_path))
    if actual == expected_data
      puts "ok #{index + 1} - #{File.basename(input)}"
    else
      puts "not ok #{index + 1} - #{File.basename(input)}"
      failed = true
    end
  rescue => e
    puts "not ok #{index + 1} - #{File.basename(input)} # #{e.message}"
    failed = true
  end
end

exit(failed ? 1 : 0)
