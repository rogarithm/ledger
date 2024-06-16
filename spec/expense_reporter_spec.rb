require_relative "../lib/expense"
require_relative "../lib/expense_reporter"

RSpec.describe ExpenseReporter, "expense reporter" do
  before(:each) do
    @rpt = ExpenseReporter.new
  end

  it "computes sum of all expense from 1 day" do
    expense_list = [
      Expense.new("4/2,4100,아침,맥모닝"),
      Expense.new("4/2,1000,여가,네이버 시리즈")
    ]

    expect(@rpt.compute_total_expense expense_list).to eq(5100)
  end

  it "computes sum of all expense from more than 2 days" do
    expense_list = [
      Expense.new("4/2,4100,아침,맥모닝"),
      Expense.new("4/3,1000,커피"),
    ]

    expect(@rpt.compute_total_expense expense_list).to eq(5100)
  end

  it "prints expense list" do
    expense_list = [
      Expense.new("4/2,4100,아침,맥모닝"),
      Expense.new("4/2,1000,커피")
    ]

    expect(@rpt.print_report expense_list).to eq(
    "2024-04-02 | 4100 | 아침 | 맥모닝\n2024-04-02 | 1000 | 커피 | "
    )
  end

  it "list expense from start date to end date" do
    expense_list = [
      Expense.new("4/4,1000,여가,네이버 시리즈"),
      Expense.new("4/6,1000,커피")
    ]

    expect(@rpt.list_in_range "4/3", "4/5", expense_list).to eq(
      "2024-04-04 | 1000 | 여가 | 네이버 시리즈"
    )
  end

  it "shows message when no expense in given range" do
    expense_list = [
      Expense.new("4/2,4100,아침,맥모닝")
    ]

    expect(@rpt.list_in_range "4/3", "4/4", expense_list).to eq(
      "no matching expense for given range!"
    )
  end
end
