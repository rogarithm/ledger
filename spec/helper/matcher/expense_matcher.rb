RSpec::Matchers.define :eq_expense do |expected_expense|
  match do |actual_expense|
    actual_expense.amount == expected_expense.amount &&
      actual_expense.category == expected_expense.category &&
      actual_expense.detail == expected_expense.detail
  end
  failure_message do |actual_expense|
    "not same with the expected expense!"
  end
end

RSpec::Matchers.define :eq_expenses do |expected_expenses|
  match do |actual_expenses|
    expected_expenses.each.with_index do |expected_expense, index|
      actual_expenses[index].amount == expected_expense.amount &&
        actual_expenses[index].category == expected_expense.category &&
        actual_expenses[index].detail == expected_expense.detail
    end
  end
  failure_message do |actual_expenses|
    "not same with the expected expenses!"
  end
end
