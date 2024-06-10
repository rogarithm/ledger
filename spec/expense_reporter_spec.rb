require_relative "../lib/expense"
require_relative "../lib/expense_reporter"

require_relative "../spec/helper/spec_helper"

RSpec.describe ExpenseReporter, "expense reporter" do
  it "computes sum of all expense from expense list" do
    expense_list = {"4/2" => [
      Expense.new("4/2,4100,아침,맥모닝"),
      Expense.new("4/2,1000,여가,네이버 시리즈"),
      Expense.new("4/2,1000,커피")
    ]}

    expect(ExpenseReporter.compute_total_expense expense_list).to eq(6100)
  end
end
