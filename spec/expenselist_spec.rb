require_relative "../lib/ledger/expense"
require_relative "../lib/ledger/expenselist"

require_relative "../spec/helper/spec_helper"

RSpec.configure do |config|
  config.filter_run_when_matching(focus: true)
  config.example_status_persistence_file_path = 'spec/pass_fail_history'
end

RSpec.describe Lgr::ExpenseList, "expense list" do
  context "filterable" do
    it "주어진 두 날짜 사이의 지출을 필터링할 수 있다" do
      exp_list = Lgr::ExpenseList.new(
        ["4/4,1,x.y", "4/6,1,c"]
      )

      expect(exp_list.list_in_range("4/3", "4/5")[0]).to eq_expense(
        Lgr::Expense.new "4/4,1,x.y"
      )
    end

    it "주어진 두 날짜 사이에 지출이 없을 경우를 처리할 수 있다" do
      exp_list = Lgr::ExpenseList.new(
        ["4/2,4,x.y"]
      )

      expect(exp_list.list_in_range "4/3", "4/4").to eq(
        "no matching expense for given range!"
      )
    end

    it "주어진 금액보다 큰 지출액을 갖는 지출을 필터링할 수 있다" do
      exp_list = Lgr::ExpenseList.new(
        ["4/4,1,x", "4/6,2,c", "4/6,4,c"]
      )

      expect(exp_list.eg_than_amount(2)).to eq_expenses(
        [Lgr::Expense.new("4/6,2,c"), Lgr::Expense.new("4/6,4,c")]
      )
    end

    it "특정 카테고리의 지출을 필터링할 수 있다" do
      exp_list = Lgr::ExpenseList.new(
        ["4/4,1,v", "4/6,2,c", "4/6,4,c"]
      )

      expect(exp_list.in_cat("c")).to eq_expenses(
        [Lgr::Expense.new("4/6,2,c"), Lgr::Expense.new("4/6,4,c")]
      )
    end
  end

  context "reportable" do
    it "특정 일자의 모든 지출액 합을 계산할 수 있다" do
      expense_list = Lgr::ExpenseList.new(
        ["4/2,4,b.m", "4/2,1,v.ns"]
      )

      expect(expense_list.compute_total_expense).to eq(5)
    end

    it "주어진 2일 이상 기간의 모든 지출액 합을 계산할 수 있다" do
      expense_list = Lgr::ExpenseList.new(
        ["4/2,4,b.m", "4/3,1,c"]
      )

      expect(expense_list.compute_total_expense).to eq(5)
    end

    it "주어진 지출 목록을 출력할 수 있다" do
      expense_list = Lgr::ExpenseList.new(
        ["4/2,4,b.m", "4/2,1,c"]
      )

      expect(expense_list.print_report).to eq(
        "2024-04-02 | 4 | b | m\n2024-04-02 | 1 | c | "
      )
    end

    it "가계부에 쓰인 모든 카테고리를 모을 수 있다" do
      expense_list = Lgr::ExpenseList.new(
        [
          "5/1,11,living.p",
          "5/1,10,meal.y",
          "5/1,4,coffee.p",
          "5/5,9,medicine",
          "5/5,18,book",
          "5/5,76,shoe"
        ]
      )

      expect(expense_list.cat_list).to eq(
        ["living", "meal", "coffee", "medicine", "book", "shoe"]
      )
    end

    it "동일한 카테고리는 중복으로 모으지 않는다" do
      expense_list = Lgr::ExpenseList.new(
        [
          "5/1,10,meal.y",
          "5/1,4,cof.p",
          "5/6,10,meal.y"
        ]
      )

      expect(expense_list.cat_list).to eq(
        ["meal", "cof"]
      )
    end

    it "금액이 큰 순서대로 정렬할 수 있다" do
      expense_list = Lgr::ExpenseList.new(
        [
          "5/1,11,living.p",
          "5/1,10,meal.y",
          "5/1,4,coffee.p",
          "5/5,9,medicine",
          "5/5,18,book 5/5,76,shoe"
        ]
      )

      expect(
        expense_list.sort_by_amt.collect {|exp| exp.amount}
      ).to eq(
        [18, 11, 10, 9, 4]
      )
    end
  end
end
