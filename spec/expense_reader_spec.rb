require_relative "../lib/ledger/expense"
require_relative "../lib/ledger/expense_reader"

require_relative "../spec/helper/spec_helper"

RSpec.describe Lgr::ExpenseReader, "reads expense list" do
  def read_expense_list txt_expense_list
    txt_expense_list.inject([]) do |expense_list, txt_expense|
      expense_list << Lgr::Expense.new(txt_expense)
    end
  end

  it "1일치의 지출 기록을 데이터베이스에 저장되는 형태로 되돌릴 수 있다" do
    reader = Lgr::ExpenseReader.new
    expense_list = read_expense_list(
      ["4/2,4,b.m", "4/2,1,v.ns"]
    )

    expect(reader.back_to_db_form(expense_list)).to eq(
      "4/2\n4,b.m\n1,v.ns\n"
    )
  end

  it "2일치의 지출 기록을 데이터베이스에 저장되는 형태로 되돌릴 수 있다" do
    reader = Lgr::ExpenseReader.new
    expense_list = read_expense_list(
      ["4/2,4,b.m", "4/2,1,v.ns",
      "4/3,4,b.m", "4/3,1,v.ns"]
    )

    expect(reader.back_to_db_form(expense_list)).to eq(
      "4/2\n4,b.m\n1,v.ns\n4/3\n4,b.m\n1,v.ns\n"
    )
  end

  it "일반 텍스트 포맷 가계부로부터 지출 정보를 가져올 수 있다" do
    raw_expense_list = <<-file_content
    4/2
    4,b,m
    1,v,ns
    1,c
    file_content

    reader = Lgr::ExpenseReader.new
    expense_list = reader.read_expense_list(raw_expense_list)

    expect(expense_list[0]).to eq_expense(Lgr::Expense.new("4/2,4,b,m"))
    expect(expense_list[1]).to eq_expense(Lgr::Expense.new("4/2,1,v,ns"))
    expect(expense_list[2]).to eq_expense(Lgr::Expense.new("4/2,1,c"))
  end

  it "불필요한 빈 칸이 있는 경우 지출 정보를 가져올 수 있다" do
    raw_expense_list = <<-file_content
    4/2
    4,b.m
    1,v.ns
    1, c.m
    2, c . pb
    2,c .sb
    file_content

    reader = Lgr::ExpenseReader.new
    expense_list = reader.read_expense_list(raw_expense_list)

    expect(expense_list[0]).to eq_expense(Lgr::Expense.new("4/2,4,b.m"))
    expect(expense_list[1]).to eq_expense(Lgr::Expense.new("4/2,1,v.ns"))
    expect(expense_list[2]).to eq_expense(Lgr::Expense.new("4/2,1,c.m"))
    expect(expense_list[3]).to eq_expense(Lgr::Expense.new("4/2,2,c.pb"))
    expect(expense_list[4]).to eq_expense(Lgr::Expense.new("4/2,2,c.sb"))
  end
end
