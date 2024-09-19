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
    def group_by_exp_type(source)
      lines = source.split("\n")

      groups = {}
      exp_type = ""
      date = ""
      lines.each do |l|
        if l =~ /^\s*[fix_exp|var_exp|income|saving]/
          exp_type = l.strip.to_sym
          groups[exp_type] ||= {}
          next
        end
        if l =~ /^\s*\d+\/\d+$/
          date = l.strip
          groups[exp_type][date] ||= []
          next
        end
        groups[exp_type][date] << l.strip
      end

      groups
    end

    def back2ledger_form(groups, padding=" ")
      result = ""

      groups.each do |exp_type, date_n_exps|
        date_n_exps = date_n_exps.sort_by do |date, ignore|
          Time.new(Time.new.year, *date.split("/").map(&:to_i))
        end.to_h
        result << "#{exp_type}\n"
        date_n_exps.each do |date, exps|
          result << "#{padding}#{date}\n"
          exps.each { |exp| result << "#{padding}#{padding}#{exp}\n" }
        end
      end

      result
    end

    def split_by_exp_type(source)
      result = {}

      group_by_exp_type(source).each do |exp_type, date_n_exps|
        ledger_nm = [Time.new.year, date_n_exps.keys[0].split("/")[0]].join("_")
        exps_in_type = back2ledger_form({ exp_type => date_n_exps }, "")
                         .split("\n")
                         .filter! { |l| l !~ /^\s*[fix_exp|var_exp|income|saving]/ }
                         .join("\n")
        result["#{exp_type.to_s}:#{ledger_nm}"] = exps_in_type
      end

      result
    end

    def make(ledgers, middle_path="", dry_run=false)
      base_dir = File.join(File.dirname(__FILE__), '..', middle_path)

      if dry_run
        puts "source is at: #{File.dirname(__FILE__)}"
        puts "source/../middle_path: #{base_dir}"
        return
      end

      ledgers.each do |where, exps|
        exp_type, ledger_nm = where.split(":")
        full_path = File.join(base_dir, exp_type)

        FileUtils.mkdir_p(full_path)

        File.open(File.join(full_path, ledger_nm), "w") do |f|
          f.write(exps)
        end
      end
    end
  end
end