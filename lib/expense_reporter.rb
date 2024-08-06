require_relative './expense'

class ExpenseReporter
  def compute_total_expense expenses
    expenses.inject(0) {|sum, expense| sum += expense.amount}
  end

  def sum_by_cat expenses, category
    compute_total_expense expenses
  end

  def report_by_cat expenses, category
    max_expense = expenses.max {|e1, e2| e1.amount.to_s.size <=> e2.amount.to_s.size}
    max_size = max_expense.amount.to_s.size

    result = [category]
    expenses.each do |expense|
      dots_to_pad = '.' * (max_size - expense.amount.to_s.size)
      result << "#{expense.at.strftime "%m/%d"}...#{dots_to_pad}#{expense.format_amount}"
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
