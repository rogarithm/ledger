require_relative "../lib/expense"
require_relative "../lib/sum"

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

RSpec.describe Expense do
  it "makes expense list from file" do
    raw_expense_list = <<-file_content
    4/2
    4100,아침,맥모닝
    1000,여가,네이버 시리즈
    1000,커피
    file_content

    expense_list = Sum.create_expense_list(raw_expense_list)
    expect(expense_list.keys[0]).to eq("4/2")

    expect(expense_list.values[0][0]).to eq_expense(Expense.new("4100,아침,맥모닝"))
    expect(expense_list.values[0][1]).to eq_expense(Expense.new("1000,여가,네이버 시리즈"))
    expect(expense_list.values[0][2]).to eq_expense(Expense.new("1000,커피"))
  end
end
