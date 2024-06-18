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
