require_relative './expense'

class ExpenseReporter
  def compute_total_expense expenses
    expenses.inject(0) {|sum, expense| sum += expense.amount}
  end

  def sum_by_cat expenses, category
    total_expense = Expense.new("1/1,#{compute_total_expense expenses},x")
    "#{category}...#{total_expense.format_amount}"
  end

  def report_by_cat expenses, category
    result = [category]
    expenses.each do |expense|
      result << "#{expense.at.strftime "%m/%d"}...#{expense.format_amount}"
    end
    result.join("\n")
  end

  def category_list expenses
    result = []
    expenses.inject(result) do |category_list, expense|
      category_list << expense.category
    end
    result.select! {|e| e != ""}
    uniq_result = result.uniq
    uniq_result
  end

  def print_report expenses
    expenses.map(&:to_s).join("\n")
  end
end
