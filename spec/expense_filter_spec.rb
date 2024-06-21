require_relative "../lib/expense"
require_relative "../lib/expense_filter"

require_relative "../spec/helper/spec_helper"

RSpec.configure do |config|
  config.filter_run_when_matching(focus: true)
  config.example_status_persistence_file_path = 'spec/pass_fail_history'
end

RSpec.describe ExpenseFilter, "expense filter" do
  def create_expense_list txt_expense_list
    txt_expense_list.inject([]) do |expense_list, txt_expense|
      expense_list << Expense.new(txt_expense)
    end
  end

  before(:each) do
    @ftr = ExpenseFilter.new
  end

  it "list expense from start date to end date" do
    expense_list = create_expense_list(
      ["4/4,1000,여가.네이버 시리즈", "4/6,1000,커피"]
    )

    expect(@ftr.list_in_range("4/3", "4/5", expense_list)[0]).to eq_expense(
      Expense.new "4/4,1000,여가.네이버 시리즈"
    )
  end

  it "shows message when no expense in given range" do
    expense_list = create_expense_list(
      ["4/2,4100,아침.맥모닝"]
    )

    expect(@ftr.list_in_range "4/3", "4/4", expense_list).to eq(
      "no matching expense for given range!"
    )
  end

  it "filter expense higher than specific amount" do
    expense_list = create_expense_list(
      ["4/4,1000,여가", "4/6,2000,커피", "4/6,4000,커피"]
    )

    expect(@ftr.eg_than_amount(2000, expense_list)).to eq_expenses(
      [Expense.new("4/6,2000,커피"), Expense.new("4/6,4000,커피")]
    )
  end
end
