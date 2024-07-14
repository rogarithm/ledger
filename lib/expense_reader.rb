require_relative "./expense"

class ExpenseReader
  def read_expense_list(raw_expenses)
    expenses = []
    current_date = ''

    raw_expenses.split("\n").each do |line|
      if line =~ /^\s*\d+\/\d+$/
        current_date = line.strip
      elsif line =~ /^$/
        next
      else
        expense = Expense.new(current_date.strip + "," + line.strip)
        expenses << expense
      end
    end

    expenses
  end

  def back_to_db_form(expenses)
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
end
