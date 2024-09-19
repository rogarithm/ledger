# frozen_string_literal: true

RSpec::Matchers.define :eq_ignore_ws do |expected|
  match do |actual|
    if actual.scan(/\n/).size > 1 and expected.scan(/\n/).size > 1
      actual = actual.split("\n").map {|l| l.lstrip}.join("\n")
      expected = expected.split("\n").map {|l| l.lstrip}.join("\n")
    end

    actual.chomp == expected.chomp
  end

  failure_message do |actual|
    "expected that #{actual.inspect} would equal #{expected.inspect} ignoring whitespace"
  end
end
