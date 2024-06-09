#!/usr/bin/env ruby

require_relative "./expense"
require_relative "./expense_reader"

# 지출 내역을 읽어온다
if ARGV.length > 1
  puts "more input than expected!"
  puts "exit..."
  return
end

raw_monthly_expenses = File.read("../ledger/#{ARGV[0]}")


monthly_expenses = ExpenseReader.create_expense_list(raw_monthly_expenses)

total_expense = 0
monthly_expenses.each do |info_by_day|
  pays_by_day = info_by_day[1]
  sum_by_day = pays_by_day.map(&:amount).sum
  total_expense += sum_by_day
  puts "#{info_by_day[0]}... #{sum_by_day}
  #{info_by_day[1].map(&:to_s).join("\n  ")}"
end
puts total_expense

