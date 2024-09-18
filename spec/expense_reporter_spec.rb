require_relative "../lib/expense"
require_relative "../lib/expense_reporter"

require_relative "../spec/helper/spec_helper"

RSpec.configure do |config|
  config.filter_run_when_matching(focus: true)
  config.example_status_persistence_file_path = 'spec/pass_fail_history'
end

RSpec.describe ExpenseReporter, "expense reporter" do
  def read_expense_list txt_expense_list
    txt_expense_list.inject([]) do |expense_list, txt_expense|
      expense_list << Expense.new(txt_expense)
    end
  end

  before(:each) do
    @rpt = ExpenseReporter.new
  end

  it "computes sum of all expense from 1 day" do
    expense_list = read_expense_list(
      ["4/2,4,b.m", "4/2,1,v.ns"]
    )

    expect(@rpt.compute_total_expense expense_list).to eq(5)
  end

  it "computes sum of all expense from more than 2 days" do
    expense_list = read_expense_list(
      ["4/2,4,b.m", "4/3,1,c"]
    )

    expect(@rpt.compute_total_expense expense_list).to eq(5)
  end

  it "prints expense list" do
    expense_list = read_expense_list(
      ["4/2,4,b.m", "4/2,1,c"]
    )

    expect(@rpt.print_report expense_list).to eq(
      "2024-04-02 | 4 | b | m\n2024-04-02 | 1 | c | "
    )
  end

  it "can collect all categories in ledger" do
    expense_list = read_expense_list(
      [
        "5/1,11,living.p",
        "5/1,10,meal.y",
        "5/1,4,coffee.p",
        "5/5,9,medicine",
        "5/5,18,book",
        "5/5,76,shoe"
      ]
    )

    expect(@rpt.category_list expense_list).to eq(
      ["living", "meal", "coffee", "medicine", "book", "shoe"]
    )
  end

  it "don't collect same category twice" do
    expense_list = read_expense_list(
      [
        "5/1,10,meal.y",
        "5/1,4,cof.p",
        "5/6,10,meal.y"
      ]
    )

    expect(@rpt.category_list expense_list).to eq(
      ["meal", "cof"]
    )
  end
end
