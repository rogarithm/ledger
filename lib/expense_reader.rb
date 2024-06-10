require_relative "./expense"

class ExpenseReader
  def self.create_expense_list(raw_monthly_expenses)
    monthly_expenses = {}
    current_date = ''

    raw_monthly_expenses.split("\n").each do |line|
      if line =~ /^\s*\d+\/\d+$/
        current_date = line.strip
        monthly_expenses[current_date] = []
      elsif line =~ /^$/
        next
      else
        expense = Expense.new(current_date.strip + "," + line)
        monthly_expenses[current_date] << expense
      end
    end

    monthly_expenses
  end
end
