require 'rake/clean'

namespace :rpt do
  #desc 'run all specs and tests'
  #task :all => [:token, :parser, :generator, :concern, :file] do
  #end

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
