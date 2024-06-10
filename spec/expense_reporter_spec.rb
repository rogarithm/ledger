require_relative "../lib/expense"
require_relative "../lib/expense_reporter"

require_relative "../spec/helper/spec_helper"

RSpec.describe ExpenseReporter, "expense reporter" do
  it "computes sum of all expense from 1 day" do
    expense_list = [
      Expense.new("4/2,4100,아침,맥모닝"),
      Expense.new("4/2,1000,여가,네이버 시리즈"),
      Expense.new("4/2,1000,커피")
    ]

    expect(ExpenseReporter.compute_total_expense expense_list).to eq(6100)
  end

  it "computes sum of all expense from more than 2 days" do
    expense_list = [
      Expense.new("4/2,4100,아침,맥모닝"),
      Expense.new("4/2,1000,여가,네이버 시리즈"),
      Expense.new("4/2,1000,커피"),
      Expense.new("4/3,1000,커피"),
    ]

    expect(ExpenseReporter.compute_total_expense expense_list).to eq(7100)
  end

end
