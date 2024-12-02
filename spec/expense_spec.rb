require_relative "../lib/ledger/expense"

require_relative "../spec/helper/spec_helper"

RSpec.describe Lgr::Expense, "expense" do
  RSpec.configure do |config|
    config.filter_run_when_matching(focus: true)
    config.example_status_persistence_file_path = 'spec/pass_fail_history'
  end

  it "지출의 category와 detail을 분리해서 저장할 수 있다" do
    expect(Lgr::Expense.new("4/2,4,b.m")).to eq_expense(Lgr::Expense.from(
      "4/2","4","b","m"
    ))
    expect(Lgr::Expense.new("4/2,1,c")).to eq_expense(Lgr::Expense.from(
      "4/2","1","c",""
    ))
  end

  it "지출은 계좌 정보를 가질 수 있다" do
    expect(Lgr::Expense.new("4/2,4,b.m,acc")).to eq_expense(Lgr::Expense.from(
      "4/2","4","b","m", "acc"
    ))
    expect(Lgr::Expense.new("4/2,1,c")).to eq_expense(Lgr::Expense.from(
      "4/2","1","c",""
    ))
  end

  it "지출에 시간 정보가 없을 경우, 기본값을 할당한다" do
    exp = Lgr::Expense.new("4/2,4,b.m,acc")
    expect(exp.at.hour).to eq(0)
    expect(exp.at.min).to eq(0)
    expect(exp.at.sec).to eq(0)
  end

  it "지출은 시간 정보를 가질 수 있다" do
    exp = Lgr::Expense.new("4/2 12:01:29,4,b.m,acc")
    expect(exp.at.hour).to eq(12)
    expect(exp.at.min).to eq(1)
    expect(exp.at.sec).to eq(29)
  end

  it "지출액을 포맷팅할 수 있다" do
    e1 = Lgr::Expense.new("4/2,500,c")
    expect(e1.format_amount).to eq("500")

    e2 = Lgr::Expense.new("4/2,1000,c")
    expect(e2.format_amount).to eq("1,000")

    e3 = Lgr::Expense.new("4/2,120800,c")
    expect(e3.format_amount).to eq("120,800")

    e4 = Lgr::Expense.new("4/2,-1000,c")
    expect(e4.format_amount).to eq("-1,000")
  end

  it "지출액 포맷팅을 되돌릴 수 있다" do
    e_x = Lgr::Expense.new("4/2,500,c")

    expect(e_x.unformat_amount("500")).to eq("500")
    expect(e_x.unformat_amount("1,000")).to eq("1000")
    expect(e_x.unformat_amount("120,800")).to eq("120800")
  end
end

