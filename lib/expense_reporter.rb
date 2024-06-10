require_relative './expense'

class ExpenseReporter
  def self.compute_total_expense monthly_expenses
    total_expense = 0


    monthly_expenses.each do |expense|
      total_expense += expense.amount
    end

    total_expense
  end
end
