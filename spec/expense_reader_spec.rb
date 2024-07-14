require_relative "../lib/expense"
require_relative "../lib/expense_reader"

require_relative "../spec/helper/spec_helper"

RSpec.describe ExpenseReader, "reads expense list" do
  def read_expense_list txt_expense_list
    txt_expense_list.inject([]) do |expense_list, txt_expense|
      expense_list << Expense.new(txt_expense)
    end
  end

  it "convert expenses of 1 day back to the form equal to db" do
    reader = ExpenseReader.new
    expense_list = read_expense_list(
      ["4/2,4100,아침.맥모닝", "4/2,1000,여가.네이버 시리즈"]
    )

    expect(reader.back_to_db_form(expense_list)).to eq(
      "4/2\n4100,아침.맥모닝\n1000,여가.네이버 시리즈\n"
    )
  end

  it "convert expenses of 2 days back to the form equal to db" do
    reader = ExpenseReader.new
    expense_list = read_expense_list(
      ["4/2,4100,아침.맥모닝", "4/2,1000,여가.네이버 시리즈",
      "4/3,4100,아침.맥모닝", "4/3,1000,여가.네이버 시리즈"]
    )

    expect(reader.back_to_db_form(expense_list)).to eq(
      "4/2\n4100,아침.맥모닝\n1000,여가.네이버 시리즈\n4/3\n4100,아침.맥모닝\n1000,여가.네이버 시리즈\n"
    )
  end

  it "from plain text file" do
    raw_expense_list = <<-file_content
    4/2
    4100,아침,맥모닝
    1000,여가,네이버 시리즈
    1000,커피
    file_content

    reader = ExpenseReader.new
    expense_list = reader.read_expense_list(raw_expense_list)

    expect(expense_list[0]).to eq_expense(Expense.new("4/2,4100,아침,맥모닝"))
    expect(expense_list[1]).to eq_expense(Expense.new("4/2,1000,여가,네이버 시리즈"))
    expect(expense_list[2]).to eq_expense(Expense.new("4/2,1000,커피"))
  end

  it "when some field has additional whitespaces" do
    raw_expense_list = <<-file_content
    4/2
    4100,아침.맥모닝
    1000,여가.네이버 시리즈 
    1000, 커피.맥도날드
    2000, 커피 . 폴바셋
    2000,커피 .스타벅스 
    file_content

    reader = ExpenseReader.new
    expense_list = reader.read_expense_list(raw_expense_list)

    expect(expense_list[0]).to eq_expense(Expense.new("4/2,4100,아침.맥모닝"))
    expect(expense_list[1]).to eq_expense(Expense.new("4/2,1000,여가.네이버 시리즈"))
    expect(expense_list[2]).to eq_expense(Expense.new("4/2,1000,커피.맥도날드"))
    expect(expense_list[3]).to eq_expense(Expense.new("4/2,2000,커피.폴바셋"))
    expect(expense_list[4]).to eq_expense(Expense.new("4/2,2000,커피.스타벅스"))
  end
end
