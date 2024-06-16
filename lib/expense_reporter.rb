require_relative './expense'

class ExpenseReporter
  def compute_total_expense expenses
    expenses.inject(0) {|sum, expense| sum += expense.amount}
  end

  def print_report monthly_expenses
    monthly_expenses.map(&:to_s).join("\n")
  end

  def list_in_range from, to, expenses
    from_month, from_day = from.split("/")
    from = Time.new(2024, from_month.to_i, from_day.to_i)
    to_month, to_day = to.split("/")
    to = Time.new(2024, to_month.to_i, to_day.to_i)

    expenses_in_range = expenses.select {|expense| expense.at >= from and expense.at <= to}

    if expenses_in_range.empty?
      return "no matching expense for given range!"
    end

    expenses_in_range.map(&:to_s).join("\n")
  end
end
