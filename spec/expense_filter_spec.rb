require_relative "../lib/ledger/expense"
require_relative "../lib/ledger/expense_filter"

require_relative "../spec/helper/spec_helper"

RSpec.configure do |config|
  config.filter_run_when_matching(focus: true)
  config.example_status_persistence_file_path = 'spec/pass_fail_history'
end

RSpec.describe Lgr::ExpenseFilter, "expense filter" do
  def read_expense_list txt_expense_list
    txt_expense_list.inject([]) do |expense_list, txt_expense|
      expense_list << Lgr::Expense.new(txt_expense)
    end
  end

  before(:each) do
    @ftr = Lgr::ExpenseFilter.new
  end

  it "list expense from start date to end date" do
    expense_list = read_expense_list(
      ["4/4,1,x.y", "4/6,1,c"]
    )

    expect(@ftr.list_in_range("4/3", "4/5", expense_list)[0]).to eq_expense(
      Lgr::Expense.new "4/4,1,x.y"
    )
  end

  it "shows message when no expense in given range" do
    expense_list = read_expense_list(
      ["4/2,4,x.y"]
    )

    expect(@ftr.list_in_range "4/3", "4/4", expense_list).to eq(
      "no matching expense for given range!"
    )
  end

  it "filter expense higher than specific amount" do
    expense_list = read_expense_list(
      ["4/4,1,x", "4/6,2,c", "4/6,4,c"]
    )

    expect(@ftr.eg_than_amount(2, expense_list)).to eq_expenses(
      [Lgr::Expense.new("4/6,2,c"), Lgr::Expense.new("4/6,4,c")]
    )
  end

  it "filter expense in specific category" do
    expense_list = read_expense_list(
      ["4/4,1,v", "4/6,2,c", "4/6,4,c"]
    )

    expect(@ftr.in_category("c", expense_list)).to eq_expenses(
      [Lgr::Expense.new("4/6,2,c"), Lgr::Expense.new("4/6,4,c")]
    )
  end
end
