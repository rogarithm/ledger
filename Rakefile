require 'rake/clean'
require_relative "./lib/ledger/preproc"
require_relative "./lib/ledger/expense_reader"
require_relative "./lib/ledger/expenselist"

namespace :rpt do
  #desc 'run all specs and tests'
  #task :all => [:token, :parser, :generator, :concern, :file] do
  #end

  #usage: rake rpt:all[2024_7]
  desc 'computes all'
  task :all, [:month, :ledger] do |task, args|
    month = args[:month]
    ledger_path = args[:ledger] ||= "../ledger"

    fix    = `cat "#{ledger_path}/dest/fix_exp/#{month}" | ./bin/fmr --sum`.to_i
    income = `cat "#{ledger_path}/dest/income/#{month}" | ./bin/fmr --sum`.to_i
    var    = `cat "#{ledger_path}/dest/var_exp/#{month}" | ./bin/fmr --sum`.to_i
    saving = `cat "#{ledger_path}/dest/saving/#{month}" | ./bin/fmr --sum`.to_i

    puts "fix   : #{fix}"
    puts "income: #{income}"
    puts "var   : #{var}"
    puts "saving: #{saving}"
    puts fix + income + var + saving
  end

  desc 'total sum by expense type'
  task :type_sum do
    csv = []
    %w[income saving fix_exp var_exp].each do |exp_type|
      src_path = File.join(File.dirname(__FILE__), *%W[.. ledger dest #{exp_type} 2024_8])
      er = Lgr::ExpenseReader.new
      csv << "#{exp_type}, #{Lgr::ExpenseList.new(er.read_expense_list(File.read(src_path))).compute_total_expense}"
    end
    csv.join("\n")
  end

  desc 'sum by big categories'
  task :cat_sum do
    %w[var_exp].each do |exp_type|
      src_path = File.join(File.dirname(__FILE__), *%W[.. ledger dest #{exp_type} 2024_8])
      er = Lgr::ExpenseReader.new
      explist = Lgr::ExpenseList.new(er.read_expense_list(File.read(src_path)))
      explist.category_list.each do |cat|
        puts "CAT: #{cat}"
        puts explist.in_category(cat)
      end
    end
  end
end

task :after do
  puts "남은 돈은 쓰지 않는 계좌로 모두 옮기기"
end

task :x do
  pp = Lgr::Preproc.new
  src_path = File.join(File.dirname(__FILE__), *%w[.. ledger source explist 2024_9])
  ignore_emp_lines = Lgr::Ledger.new(File.read(src_path))
                                      .ignore_empty_lines
  x = pp.split_by_exp_type(ignore_emp_lines, from_csv: true)
  pp.make(x, "../../ledger/dest")
end
