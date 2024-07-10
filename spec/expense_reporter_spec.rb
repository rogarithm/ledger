require_relative "../lib/expense"
require_relative "../lib/expense_reporter"

require_relative "../spec/helper/spec_helper"

RSpec.configure do |config|
  config.filter_run_when_matching(focus: true)
  config.example_status_persistence_file_path = 'spec/pass_fail_history'
end

RSpec.describe ExpenseReporter, "expense reporter" do
  def create_expense_list txt_expense_list
    txt_expense_list.inject([]) do |expense_list, txt_expense|
      expense_list << Expense.new(txt_expense)
    end
  end

  before(:each) do
    @rpt = ExpenseReporter.new
  end

  it "convert expenses of 1 day back to the form equal to db" do
    expense_list = create_expense_list(
      ["4/2,4100,아침.맥모닝", "4/2,1000,여가.네이버 시리즈"]
    )

    expect(@rpt.back_to_db_form(expense_list)).to eq(
      "4/2\n4100,아침.맥모닝\n1000,여가.네이버 시리즈\n"
    )
  end

  it "convert expenses of 2 days back to the form equal to db" do
    expense_list = create_expense_list(
      ["4/2,4100,아침.맥모닝", "4/2,1000,여가.네이버 시리즈",
      "4/3,4100,아침.맥모닝", "4/3,1000,여가.네이버 시리즈"]
    )

    expect(@rpt.back_to_db_form(expense_list)).to eq(
      "4/2\n4100,아침.맥모닝\n1000,여가.네이버 시리즈\n4/3\n4100,아침.맥모닝\n1000,여가.네이버 시리즈\n"
    )
  end

  it "computes sum of all expense from 1 day" do
    expense_list = create_expense_list(
      ["4/2,4100,아침.맥모닝", "4/2,1000,여가.네이버 시리즈"]
    )

    expect(@rpt.compute_total_expense expense_list).to eq(5100)
  end

  it "computes sum of all expense from more than 2 days" do
    expense_list = create_expense_list(
      ["4/2,4100,아침.맥모닝", "4/3,1000,커피"]
    )

    expect(@rpt.compute_total_expense expense_list).to eq(5100)
  end

  it "prints expense list" do
    expense_list = create_expense_list(
      ["4/2,4100,아침.맥모닝", "4/2,1000,커피"]
    )

    expect(@rpt.print_report expense_list).to eq(
      "2024-04-02 | 4100 | 아침 | 맥모닝\n2024-04-02 | 1000 | 커피 | "
    )
  end

  it "can collect all categories in ledger" do
    expense_list = create_expense_list(
      ["5/1,11000,생필품.파스", "5/1,10000,식사.육장정",
       "5/1,4300,커피.프로스퍼", "5/5,9000,약", "5/5,18260,책", "5/5,76500,신발"]
    )

    expect(@rpt.category_list expense_list).to eq(
      ["생필품", "식사", "커피", "약", "책", "신발"]
    )
  end

  it "don't collect same category twice" do
    expense_list = create_expense_list(
      ["5/1,11000,생필품.파스", "5/1,10000,식사.육장정",
       "5/1,4300,커피.프로스퍼", "5/5,9000,약", "5/5,18260,책", "5/5,76500,신발",
       "5/6,10000,식사.육장정"]
    )

    expect(@rpt.category_list expense_list).to eq(
      ["생필품", "식사", "커피", "약", "책", "신발"]
    )
  end
end
