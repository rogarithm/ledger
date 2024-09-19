require_relative "./expense"

module Lgr
  class ExpenseList < Array
    def initialize(exp_list)
      super(
        exp_list.inject([]) do |res, exp|
          res << Lgr::Expense.new(exp)
        end
      )
    end
  end
end
