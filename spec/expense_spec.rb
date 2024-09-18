require_relative "../lib/expense"

require_relative "../spec/helper/spec_helper"

RSpec.describe Expense, "expense" do
  it "parse category and detail by splitting" do
    expect(Expense.new("4/2,4,b.m")).to eq_expense(Expense.from(
      "4/2","4","b","m"
    ))
    expect(Expense.new("4/2,1,c")).to eq_expense(Expense.from(
      "4/2","1","c",""
    ))
  end

  it "format amount" do
    e1 = Expense.new("4/2,500,c")
    expect(e1.format_amount).to eq("500")

    e2 = Expense.new("4/2,1000,c")
    expect(e2.format_amount).to eq("1,000")

    e3 = Expense.new("4/2,120800,c")
    expect(e3.format_amount).to eq("120,800")
  end

  it "undo format amount" do
    e_x = Expense.new("4/2,500,c")

    expect(e_x.unformat_amount("500")).to eq("500")
    expect(e_x.unformat_amount("1,000")).to eq("1000")
    expect(e_x.unformat_amount("120,800")).to eq("120800")
  end
end

