# frozen_string_literal: true

module Lgr
  class ReservedList < Array
    def initialize(source)
      super(source.split("\n"))
    end

    def convert2ledger month
      res = []
      self.each do |rsv|
        res << Lgr::ReservedExp.make_saving(rsv, month)
      end
      res
    end
  end

  class ReservedExp < String
    def initialize source, month, exp_type
      desc, date, amt, acc = source.split(":")
      date = "#{month}/#{date.split("/")[1]}"
      super("#{acc}\n #{exp_type}\n  #{date}\n  #{amt},#{desc}\n")
    end

    def self.make_saving info, month
      self.new(info, month, "saving")
    end
  end
end
