require_relative "../lib/expense"
require_relative "../lib/expense_reader"

require_relative "../spec/helper/spec_helper"

RSpec.describe ExpenseReader, "expense reader" do
  it "makes expense list from text file" do
    raw_expense_list = <<-file_content
    4/2
    4100,아침,맥모닝
    1000,여가,네이버 시리즈
    1000,커피
    file_content

    reader = ExpenseReader.new
    expense_list = reader.create_expense_list(raw_expense_list)

    expect(expense_list[0]).to eq_expense(Expense.new("4/2,4100,아침,맥모닝"))
    expect(expense_list[1]).to eq_expense(Expense.new("4/2,1000,여가,네이버 시리즈"))
    expect(expense_list[2]).to eq_expense(Expense.new("4/2,1000,커피"))
  end
end
