require 'rake/clean'
require_relative "./lib/ledger/preproc"

namespace :rpt do
  #desc 'run all specs and tests'
  #task :all => [:token, :parser, :generator, :concern, :file] do
  #end

  #usage: rake rpt:all[2024_7]
  desc 'computes all'
  task :all, [:month, :ledger] do |task, args|
    month = args[:month]
    ledger_path = args[:ledger] ||= "../ledger"

    fix    = `cat "#{ledger_path}/fix_exp/#{month}" | ./bin/fmr --sum`.to_i
    income = `cat "#{ledger_path}/income/#{month}" | ./bin/fmr --sum`.to_i
    var    = `cat "#{ledger_path}/var_exp/#{month}" | ./bin/fmr --sum`.to_i
    saving = `cat "#{ledger_path}/saving/#{month}" | ./bin/fmr --sum`.to_i

    puts "fix:       #{fix}"
    puts "income: #{income}"
    puts "var:       #{var}"
    puts "saving: #{saving}"
    puts fix + income + var + saving
  end
end

task :x do
  pp = Lgr::Preproc.new
  src_path = File.join(File.dirname(__FILE__), *%w[.. ledger source t_2024_8])
  ignore_emp_lines = Lgr::Ledger.new(File.read(src_path))
                                      .ignore_empty_lines
  x = pp.split_by_exp_type(ignore_emp_lines)
  pp.make(x, "../../ledger/x")
end
