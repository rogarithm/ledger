# frozen_string_literal: true

RSpec::Matchers.define :pretty_formatted do |ignore|
  match do |date_n_exps_list|
    date_n_exps_list.each do |date_n_exps|
      date_n_exps.split("\n").each do |l|
        if l =~ /^\s*\d+\/\d+$/
          l =~ /^ \d+\/\d+$/
        else
          l =~ /^  .*$/
        end
      end
    end
  end

  failure_message do |date_n_exps_list|
    "expected that #{date_n_exps_list.inspect} would pretty formatted"
  end
end
