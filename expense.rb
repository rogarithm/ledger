class Expense
  attr_reader :amount, :where, :category

  def initialize(data)
    amount, category, where = data.split(",")
    @amount = amount.to_i
    @category = category
    @where = where
  end

  def to_s
"#{self.amount} | #{self.category} | #{self.where}"
  end
end

#puts Expense.new('a').to_s
#puts Expense.new('a,b').to_s
#puts Expense.new('a,b,c').to_s
