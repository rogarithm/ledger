require_relative './expense'

class ExpenseReporter
  def compute_total_expense expenses
    expenses.inject(0) {|sum, expense| sum += expense.amount}
  end

  def category_list expenses
    result = []
    expenses.inject(result) do |category_list, expense|
      category_list << expense.category
    end
    uniq_result = result.uniq
    uniq_result
  end

  def back_to_db_form expenses
    result = ""
    expenses.group_by { |expense| expense.at }.transform_values do |expense_group|
      result += "#{expense_group[0].at.strftime("%m/%d").sub(/^0/,'').sub(/\/0/,'/')}\n"
      expense_group.each do |expense|
        if expense.detail != nil
          result += "#{expense.amount},#{expense.category}.#{expense.detail}\n"
        else
          result += "#{expense.amount},#{expense.category}\n"
        end
      end
    end
    result
  end

  def print_report expenses
    expenses.map(&:to_s).join("\n")
  end
end
