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
