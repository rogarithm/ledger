require_relative './expense'

class ExpenseFilter
  def in_category category, expenses
    filtered_expenses = expenses.select {|expense| expense.category != nil and expense.category.start_with?(category)}

    if filtered_expenses.empty?
      return "no expense for given category!"
    end

    filtered_expenses
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

    expenses_in_range
  end

  def eg_than_amount amount, expenses
    filtered_expenses = expenses.select {|expense| expense.amount >= amount}

    if filtered_expenses.empty?
      return "no expense that has higher or equal amount for given amount!"
    end

    filtered_expenses
  end

  def le_than_amount amount, expenses
    filtered_expenses = expenses.select {|expense| expense.amount <= amount}

    if filtered_expenses.empty?
      return "no expense that has less or equal amount for given amount!"
    end

    filtered_expenses
  end
end

