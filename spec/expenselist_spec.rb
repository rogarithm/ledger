require_relative "../lib/ledger/expense"
require_relative "../lib/ledger/expenselist"

require_relative "../spec/helper/spec_helper"

RSpec.configure do |config|
  config.filter_run_when_matching(focus: true)
  config.example_status_persistence_file_path = 'spec/pass_fail_history'
end

RSpec.describe Lgr::ExpenseList, "expense list" do
  context "filterable" do
    it "list expense from start date to end date" do
      exp_list = Lgr::ExpenseList.new(
        ["4/4,1,x.y", "4/6,1,c"]
      )

      expect(exp_list.list_in_range("4/3", "4/5")[0]).to eq_expense(
        Lgr::Expense.new "4/4,1,x.y"
      )
    end

    it "shows message when no expense in given range" do
      exp_list = Lgr::ExpenseList.new(
        ["4/2,4,x.y"]
      )

      expect(exp_list.list_in_range "4/3", "4/4").to eq(
        "no matching expense for given range!"
      )
    end

    it "filter expense higher than specific amount" do
      exp_list = Lgr::ExpenseList.new(
        ["4/4,1,x", "4/6,2,c", "4/6,4,c"]
      )

      expect(exp_list.eg_than_amount(2)).to eq_expenses(
        [Lgr::Expense.new("4/6,2,c"), Lgr::Expense.new("4/6,4,c")]
      )
    end

    it "filter expense in specific category" do
      exp_list = Lgr::ExpenseList.new(
        ["4/4,1,v", "4/6,2,c", "4/6,4,c"]
      )

      expect(exp_list.in_category("c")).to eq_expenses(
        [Lgr::Expense.new("4/6,2,c"), Lgr::Expense.new("4/6,4,c")]
      )
    end
  end

  context "reportable" do
    it "computes sum of all expense from 1 day" do
      expense_list = Lgr::ExpenseList.new(
        ["4/2,4,b.m", "4/2,1,v.ns"]
      )

      expect(expense_list.compute_total_expense).to eq(5)
    end

    it "computes sum of all expense from more than 2 days" do
      expense_list = Lgr::ExpenseList.new(
        ["4/2,4,b.m", "4/3,1,c"]
      )

      expect(expense_list.compute_total_expense).to eq(5)
    end

    it "prints expense list" do
      expense_list = Lgr::ExpenseList.new(
        ["4/2,4,b.m", "4/2,1,c"]
      )

      expect(expense_list.print_report).to eq(
        "2024-04-02 | 4 | b | m\n2024-04-02 | 1 | c | "
      )
    end

    it "can collect all categories in ledger" do
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

      expect(expense_list.category_list).to eq(
        ["living", "meal", "coffee", "medicine", "book", "shoe"]
      )
    end

    it "don't collect same category twice" do
      expense_list = Lgr::ExpenseList.new(
        [
          "5/1,10,meal.y",
          "5/1,4,cof.p",
          "5/6,10,meal.y"
        ]
      )

      expect(expense_list.category_list).to eq(
        ["meal", "cof"]
      )
    end
  end
end
