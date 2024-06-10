#!/usr/bin/env ruby

require_relative "./expense"
require_relative "./expense_reader"
require_relative "./expense_reporter"

# 지출 내역을 읽어온다
if ARGV.length > 1
  puts "more input than expected!"
  puts "exit..."
  return
end

raw_monthly_expenses = File.read("../ledger/#{ARGV[0]}")

reader = ExpenseReader.new
monthly_expenses = reader.create_expense_list(raw_monthly_expenses)

reporter = ExpenseReporter.new
puts reporter.compute_total_expense monthly_expenses
puts reporter.print_report monthly_expenses
