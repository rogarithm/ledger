require "fileutils"

module Lgr
  class Ledger < String
    def initialize(source)
      super(source)
    end

    def ignore_lines_matching(matcher)
      lines = self.split("\n")

      result = []
      lines.each do |l|
        next if l =~ matcher
        result << l
      end

      Lgr::Ledger.new(result.join("\n").chomp)
    end

    def ignore_empty_lines
      ignore_lines_matching(/^$/)
    end

    def ignore_account_lines
      ignore_lines_matching(/^[a-zA-Z].*/)
    end
  end

  class Preproc
    def group_by_exp_type(ledger, from_csv: false)
      lines = ledger.split("\n")

      groups = {}
      acc, exp_type, date = "", "", ""
      lines.each do |l|
        case
        when account?(l) then
          acc = l.strip
        when exp_type?(l) then
          exp_type = l.strip.to_sym
          groups[exp_type] ||= {}
        when from_csv
          dateish, exp = l.split(",")[0].strip, l.split(",")[1..-1].join(",").strip
          date, time = dateish.split(" ")
          exp = time << "," << exp if time
          groups[exp_type][date] ||= []
          exp = acc == "" ? exp : exp << "," << acc
          groups[exp_type][date] << exp
        when date?(l) then
          date = l.strip
          groups[exp_type][date] ||= []
        else
          exp = acc == "" ? l.strip : l.strip << "," << acc
          groups[exp_type][date] << exp
        end
      end

      groups
    end

    def back2ledger_form(groups, padding: " ", extra_paddings: {}, ignore_exp_type: false)
      ledger = ""
      exp_type_pad = extra_paddings[:exp_type] || ""
      date_pad = extra_paddings[:date] || padding
      exp_pad = extra_paddings[:exp] || padding + padding

      groups.each do |exp_type, date_n_exps|
        date_n_exps = date_n_exps.sort_by do |date, ignore|
          Time.new(Time.new.year, *date.split("/").map(&:to_i))
        end.to_h
        ledger << "#{exp_type_pad}#{exp_type}\n" if ignore_exp_type == false
        date_n_exps.each do |date, exps|
          ledger << "#{date_pad}#{date}\n"
          exps.each { |exp| ledger << "#{exp_pad}#{exp}\n" }
        end
      end

      Lgr::Ledger.new(ledger)
    end

    def split_by_exp_type(ledger, from_csv: false)
      result = {}

      group_by_exp_type(ledger, from_csv: from_csv).each do |exp_type, date_n_exps|
        ledger_nm = [Time.new.year, find_month(date_n_exps)].join("_")
        exps_in_type = back2ledger_form({ exp_type => date_n_exps }, padding: "")
                         .split("\n")
                         .filter! { |l| l !~ /^\s*[fix_exp|var_exp|income|saving]/ }
                         .join("\n")
        result["#{exp_type.to_s}:#{ledger_nm}"] = exps_in_type
      end

      result
    end

    def find_month(date_n_exps)
      months = date_n_exps.keys.map {|md| md.split("/")[0].to_i}
                          .reverse
      months[0].to_s
    end

    def make(ledgers, middle_path="", dry_run=false)
      base_dir = File.join(File.dirname(__FILE__), '..', middle_path)

      if dry_run
        puts "source is at: #{File.dirname(__FILE__)}"
        puts "source/../middle_path: #{base_dir}"
        return
      end

      ledgers.each do |where, date_n_exps|
        exp_type, ledger_nm = where.split(":")
        full_path = File.join(base_dir, exp_type)

        FileUtils.mkdir_p(full_path)

        File.open(File.join(full_path, ledger_nm), "w") do |f|
          f.write(pretty_format(date_n_exps))
        end
      end
    end

    def pretty_format(date_n_exps, dummy_exp_type: "x")
      ledger = "#{dummy_exp_type}\n" << date_n_exps
      groups = group_by_exp_type(ledger)
      back2ledger_form(groups, padding: " ", extra_paddings: {:date => "", :exp => " "}, ignore_exp_type: true)
    end

    private

    def date?(l)
      l =~ /^\s*\d+\/\d+$/
    end

    def exp_type?(l)
      l =~ /^\s*(fix_exp|var_exp|income|saving|x)/
    end

    def account?(l)
      l =~ /^\s*(shinhan|kakao|mirae|toss|kakao-pay)/
    end
  end
end
