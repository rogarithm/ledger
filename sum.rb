#!/usr/bin/env ruby

# 지출 내역을 읽어온다
pay_list = File.read('../ledger/2024_3')

all_info = {}
current_month_date = ''
pay_list.split().each do |elem|
  if elem =~ /^\d+\/\d+$/ # 월/일 형식을 키로 넣는다
#    puts "putting #{elem} as key..."
    all_info[elem] = []
    current_month_date = elem
  elsif elem =~ /^$/
    next
  else # 다음 월/일 형식이 나오기 전까지 지출 내역을 추가한다
#    puts "putting #{elem} as value..."
    all_info[current_month_date] << elem
  end
end

#p all_info

sum_all = 0
all_info.each do |info_by_day|
  pays_by_day = info_by_day[1].map {|p| p.to_i}
  sum_by_day = pays_by_day.sum
  sum_all += sum_by_day
  puts "sum of #{info_by_day[0]} is: #{sum_by_day} ... #{info_by_day[1]}"
end
puts sum_all
