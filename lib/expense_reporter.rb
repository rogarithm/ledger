require_relative './expense'

class ExpenseReporter
  def self.compute_total_expense monthly_expenses
    total_expense = 0

    monthly_expenses.each do |info_by_day|
      pays_by_day = info_by_day[1]
      sum_by_day = pays_by_day.map(&:amount).sum
      total_expense += sum_by_day
      puts "#{info_by_day[0]}... #{sum_by_day}
  #{info_by_day[1].map(&:to_s).join("\n  ")}"
    end

    total_expense
  end
end
