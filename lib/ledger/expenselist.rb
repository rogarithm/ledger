require_relative "./expense"

module Lgr
  module Reportable
    def compute_total_expense
      self.inject(0) {|sum, expense| sum += expense.amount}
    end

    def sum_by_cat
      self.compute_total_expense
    end

    def report_by_cat category
      max_expense = self.max {|e1, e2| e1.amount.to_s.size <=> e2.amount.to_s.size}
      max_size = max_expense.amount.to_s.size

      result = [category]
      self.each do |expense|
        dots_to_pad = '.' * (max_size - expense.amount.to_s.size)
        result << "#{expense.at.strftime "%m/%d"}...#{dots_to_pad}#{expense.format_amount}"
      end
      result.join("\n")
    end

    def category_list
      result = []
      self.inject(result) do |category_list, expense|
        category_list << expense.category
      end
      result.select! {|e| e != ""}
      uniq_result = result.uniq
      uniq_result
    end

    def print_report
      self.map(&:to_s).join("\n")
    end
  end

  module Filterable
    def in_category category
      filtered_expenses = self.select {|expense| expense.category != nil and expense.category.start_with?(category)}

      if filtered_expenses.empty?
        return "no expense for given category!"
      end

      filtered_expenses
    end

    def list_in_range from, to
      from_month, from_day = from.split("/")
      from = Time.new(2024, from_month.to_i, from_day.to_i)
      to_month, to_day = to.split("/")
      to = Time.new(2024, to_month.to_i, to_day.to_i)

      expenses_in_range = self.select {|expense| expense.at >= from and expense.at <= to}

      if expenses_in_range.empty?
        return "no matching expense for given range!"
      end

      expenses_in_range
    end

    def eg_than_amount amount
      filtered_expenses = self.select {|expense| expense.amount >= amount}

      if filtered_expenses.empty?
        return "no expense that has higher or equal amount for given amount!"
      end

      filtered_expenses
    end

    def le_than_amount amount
      filtered_expenses = self.select {|expense| expense.amount <= amount}

      if filtered_expenses.empty?
        return "no expense that has less or equal amount for given amount!"
      end

      filtered_expenses
    end
  end

  class ExpenseList < Array
    include Filterable
    include Reportable

    def initialize(exp_list)
      super(
        exp_list.inject([]) do |res, exp|
          res << Lgr::Expense.new(exp)
        end
      )
    end
  end
end
