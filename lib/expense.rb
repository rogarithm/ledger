class Expense
  attr_reader :at, :amount, :where, :category

  def initialize(data)
    at, amount, category, where = data.split(",")
    month, day = at.split("/")
    @at = Time.new(2024, month, day)
    @amount = amount.to_i
    @category = category
    @where = where
  end

  def to_s
"#{self.at.strftime "%Y-%m-%d"} | #{self.amount} | #{self.category} | #{self.where}"
  end
end
