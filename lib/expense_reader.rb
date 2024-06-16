require_relative "./expense"

class ExpenseReader
  def create_expense_list(raw_expenses)
    expenses = []
    current_date = ''

    raw_expenses.split("\n").each do |line|
      if line =~ /^\s*\d+\/\d+$/
        current_date = line.strip
      elsif line =~ /^$/
        next
      else
        expense = Expense.new(current_date.strip + "," + line)
        expenses << expense
      end
    end

    expenses
  end
end
