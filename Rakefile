require 'rake/clean'
require_relative "./lib/ledger/preproc"
require_relative "./lib/ledger/expense_reader"
require_relative "./lib/ledger/expenselist"

#usage: rake type_sum[9]
desc 'total sum by expense type'
task :type_sum, [:month] do |ignore, args|
  file_nm = "2024_#{args[:month]}"
  csv = []
  %w[income saving fix_exp var_exp].each do |exp_type|
    src_path = File.join(File.dirname(__FILE__), *%W[.. ledger dest #{exp_type} #{file_nm}])
    er = Lgr::ExpenseReader.new
    explist = Lgr::ExpenseList.new(er.read_expense_list(File.read(src_path)))
    csv << "#{exp_type}, #{explist.compute_total_expense}"
  end
  puts csv.join("\n")
end

desc 'sum by big categories'
task :cat_sum, [:month] do |ignore, args|
  file_nm = "2024_#{args[:month]}"
  %w[var_exp].each do |exp_type|
    src_path = File.join(File.dirname(__FILE__), *%W[.. ledger dest #{exp_type} #{file_nm}])
    er = Lgr::ExpenseReader.new
    explist = Lgr::ExpenseList.new(er.read_expense_list(File.read(src_path)))
    explist.category_list.each do |cat|
      puts "CAT: #{cat}"
      puts explist.in_category(cat)
    end
  end
end

task :prep, [:month] do |ignore, args|
  file_nm = "2024_#{args[:month]}"
  pp = Lgr::Preproc.new
  src_path = File.join(File.dirname(__FILE__), *%W[.. ledger source explist #{file_nm}])
  ignore_emp_lines = Lgr::Ledger.new(File.read(src_path))
                                      .ignore_empty_lines
  x = pp.split_by_exp_type(ignore_emp_lines, from_csv: true)
  pp.make(x, "../../ledger/dest")
end
