RSpec::Matchers.define :eq_expense do |expected_expense|
  match do |actual_expense|
    actual_expense.amount == expected_expense.amount &&
      actual_expense.category == expected_expense.category &&
      actual_expense.where == expected_expense.where
  end
  failure_message do |actual_expense|
    "#{generate_node_info_msg actual_expense, expected_expense}\n"
  end
end
