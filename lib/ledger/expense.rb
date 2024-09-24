module Lgr
  class Expense
    attr_reader :at, :amount, :category, :detail

    def initialize(data)
      at, amount, category, account = data.split(",").map! {|x| x.strip}
      category, detail = category.split(".").map! {|x| x.strip}
      month, day = at.split("/")
      @at = Time.new(Time.new.year, month, day)
      @amount = amount.to_i
      @category = category
      @detail = detail
      @account = account || ""
    end

    def self.from(at, amount, category, detail, account="")
      new("#{at},#{amount},#{category}.#{detail},#{account}")
    end

    def to_s
      "#{self.at.strftime "%Y-%m-%d"} | #{self.amount} | #{self.category} | #{self.detail}"
    end

    def format_amount
      self.amount
          .to_s
          .gsub(/\D/, '')
          .reverse
          .gsub(/.{3}/, '\0,')
          .sub(/,$/, '')
          .reverse
    end

    def unformat_amount amount
      amount
        .gsub(/,/, '')
    end

  end
end
