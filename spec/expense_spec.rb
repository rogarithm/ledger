require_relative "../lib/expense"

require_relative "../spec/helper/spec_helper"

RSpec.describe Expense, "expense" do
  it "parse category and detail by splitting" do
    expect(Expense.new("4/2,4100,아침.맥모닝")).to eq_expense(Expense.from("4/2","4100","아침","맥모닝"))
    expect(Expense.new("4/2,1000,커피")).to eq_expense(Expense.from("4/2","1000","커피",""))
  end
end

