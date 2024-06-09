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


monthly_expenses = ExpenseReader.create_expense_list(raw_monthly_expenses)


puts ExpenseReporter.compute_total_expense monthly_expenses
