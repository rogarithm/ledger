require_relative './expense'

class ExpenseReporter
  def self.compute_total_expense expenses
    expenses.inject(0) {|sum, expense| sum += expense.amount}
  end

  def self.print_report monthly_expenses
    monthly_expenses.map(&:to_s).join("\n")
  end
end
