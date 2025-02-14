require_relative "./expense"

module Lgr
  module Reportable
    def compute_total_expense
      self.inject(0) {|sum, expense| sum += expense.amount}
    end

    def sum_by_cat cat
      Lgr::ExpenseList.from_exps(self.select {|exp| exp.category == cat})
                      .compute_total_expense
    end

    def sum_by_cat_n_detail cat, detail
      Lgr::ExpenseList.from_exps(self.select {|exp| exp.category == cat and exp.detail == detail})
                      .compute_total_expense
    end

    def report_by_cat cat
      max_exp = self.max {|e1, e2| e1.amount.to_s.size <=> e2.amount.to_s.size}
      max_size = max_exp.amount.to_s.size

      result = [cat]
      self.each do |exp|
        dots_to_pad = '.' * (max_size - exp.amount.to_s.size)
        result << "#{exp.at.strftime "%m/%d"}...#{dots_to_pad}#{exp.format_amount}"
      end
      result.join("\n")
    end

    def report_by_cat_n_detail cat_n_detail
      cnd_info = []
      cnd = cat_n_detail
      cnd.keys.each do |cat|
        cnd_info << [cat, '', self.sum_by_cat(cat)]
        no_cat_sum = self.sum_by_cat_n_detail(cat, nil)
        cnd_info << ['', '상세항목 없음', no_cat_sum] if no_cat_sum != 0
        details = cnd.values[0]
        details.each do |detail|
          cnd_info << ['', detail.to_s, self.sum_by_cat_n_detail(cat, detail.to_s)]
        end
      end
      cnd_info
    end

    def cat_list
      result = []
      self.inject(result) do |cat_list, exp|
        cat_list << exp.category
      end
      result.select! {|e| e != ""}
      uniq_result = result.uniq
      uniq_result
    end

    def details_of_cat cat
      self.select {|exp| exp.category == cat}
          .reject {|exp| exp.detail == nil}
          .map {|exp| exp.detail.to_sym}
          .uniq
    end

    def make_cat_n_detail
      result = []
      self.cat_list.map do |cat|
        cnd = {}
        cnd[cat] = self.details_of_cat(cat)
        result << cnd
      end
      result
    end

    def print_report
      self.map(&:to_s).join("\n")
    end
  end

  module Filterable
    def in_cat cat
      exps_in_cat = self.select do |exp|
        exp.category != nil and exp.category.start_with?(cat)
      end

      if exps_in_cat.empty?
        return "no expense for given category!"
      end

      Lgr::ExpenseList.from_exps(exps_in_cat)
    end

    def list_in_range from, to
      from_month, from_day = from.split("/")
      from = Time.new(2024, from_month.to_i, from_day.to_i)
      to_month, to_day = to.split("/")
      to = Time.new(2024, to_month.to_i, to_day.to_i)

      exps_in_range = self.select {|exp| exp.at >= from and exp.at <= to}

      if exps_in_range.empty?
        return "no matching expense for given range!"
      end

      Lgr::ExpenseList.from_exps(exps_in_range)
    end

    def sort_by_amt(order: :desc, len: self.size)
      sorted_exps = self.sort_by { |exp| exp.amount }
                        .reverse!
                        .take(len)
      Lgr::ExpenseList.from_exps(sorted_exps)
    end

    def eg_than_amount amount
      filtered_exps = self.select {|exp| exp.amount >= amount}

      if filtered_exps.empty?
        return "no expense that has higher or equal amount for given amount!"
      end

      Lgr::ExpenseList.from_exps(filtered_exps)
    end

    def le_than_amount amount
      filtered_exps = self.select {|exp| exp.amount <= amount}

      if filtered_exps.empty?
        return "no expense that has less or equal amount for given amount!"
      end

      Lgr::ExpenseList.from_exps(filtered_exps)
    end
  end

  class ExpenseList < Array
    include Filterable
    include Reportable

    def initialize(plain_exp_list)
      super(
        plain_exp_list.inject([]) do |res, exp|
          res << Lgr::Expense.new(exp)
        end
      )
    end

    def self.from_exps exps
      self.new([]).concat(exps)
    end
  end
end
