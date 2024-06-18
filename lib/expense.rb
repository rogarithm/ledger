class Expense
  attr_reader :at, :amount, :category, :detail

  def initialize(data)
    at, amount, category = data.split(",")
    category, detail = category.split(".")
    month, day = at.split("/")
    @at = Time.new(2024, month, day)
    @amount = amount.to_i
    @category = category
    @detail = detail
  end

  def self.from(at, amount, category, detail)
    new("#{at},#{amount},#{category}.#{detail}")
  end

  def to_s
"#{self.at.strftime "%Y-%m-%d"} | #{self.amount} | #{self.category} | #{self.detail}"
  end
end
