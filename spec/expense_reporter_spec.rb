require_relative "../lib/expense"
require_relative "../lib/expense_reporter"

RSpec.describe ExpenseReporter, "expense reporter" do
  def create_expense_list txt_expense_list
    txt_expense_list.inject([]) do |expense_list, txt_expense|
      expense_list << Expense.new(txt_expense)
    end
  end

  before(:each) do
    @rpt = ExpenseReporter.new
  end

  it "computes sum of all expense from 1 day" do
    expense_list = create_expense_list(
      ["4/2,4100,아침,맥모닝", "4/2,1000,여가,네이버 시리즈"]
    )

    expect(@rpt.compute_total_expense expense_list).to eq(5100)
  end

  it "computes sum of all expense from more than 2 days" do
    expense_list = create_expense_list(
      ["4/2,4100,아침,맥모닝", "4/3,1000,커피"]
    )

    expect(@rpt.compute_total_expense expense_list).to eq(5100)
  end

  it "prints expense list" do
    expense_list = create_expense_list(
      ["4/2,4100,아침,맥모닝", "4/2,1000,커피"]
    )

    expect(@rpt.print_report expense_list).to eq(
      "2024-04-02 | 4100 | 아침 | 맥모닝\n2024-04-02 | 1000 | 커피 | "
    )
  end

  it "list expense from start date to end date" do
    expense_list = create_expense_list(
      ["4/4,1000,여가,네이버 시리즈", "4/6,1000,커피"]
    )

    expect(@rpt.list_in_range "4/3", "4/5", expense_list).to eq(
      "2024-04-04 | 1000 | 여가 | 네이버 시리즈"
    )
  end

  it "shows message when no expense in given range" do
    expense_list = create_expense_list(
      ["4/2,4100,아침,맥모닝"]
    )

    expect(@rpt.list_in_range "4/3", "4/4", expense_list).to eq(
      "no matching expense for given range!"
    )
  end

  it "filter expense higher than specific amount" do
    expense_list = create_expense_list(
      ["4/4,1000,여가", "4/6,2000,커피", "4/6,4000,커피"]
    )

    expect(@rpt.eg_than_amount(2000, expense_list)).to eq(
      "2024-04-06 | 2000 | 커피 | \n2024-04-06 | 4000 | 커피 | "
    )
  end
end
