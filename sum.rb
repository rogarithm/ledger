#!/usr/bin/env ruby

require_relative './expense'

# 지출 내역을 읽어온다
if ARGV.length > 1
  puts "more input than expected!"
  puts "exit..."
  return
end

raw_monthly_expenses = File.read("../ledger/#{ARGV[0]}")

monthly_expenses = {}
current_date = ''
raw_monthly_expenses.split("\n").each do |line|
  if line =~ /^\d+\/\d+$/ # 날짜는 키로 쓴다
#    puts "putting #{line} as key..."
    current_date = line
    monthly_expenses[current_date] = []
  elsif line =~ /^$/
    next
  else # 다음 날짜 전까지 지출 내역을 추가한다
#    puts "putting #{line} as value..."
    expense = Expense.new(line)
    monthly_expenses[current_date] << expense
  end
end

#p monthly_expenses

total_expense = 0
monthly_expenses.each do |info_by_day|
  pays_by_day = info_by_day[1]
  sum_by_day = pays_by_day.map(&:amount).sum
  total_expense += sum_by_day
  puts "#{info_by_day[0]}... #{sum_by_day}
  #{info_by_day[1].map(&:to_s).join("\n  ")}"
end
puts total_expense
