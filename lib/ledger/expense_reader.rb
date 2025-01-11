require_relative "./expense"

module Lgr
  class ExpenseReader
    def read_expense_list(raw_exps)
      exps = []
      current_date = ''

      raw_exps.split("\n").each do |line|
        if line =~ /^\s*\d+\/\d+$/
          current_date = line.strip
        elsif line =~ /^$/
          next
        else
          if line.split(",").size < 4 # 지출 내역이 시:분:초를 포함하지 않는다
            exp = current_date.strip + "," + line.split(",").map(&:strip).join(",")
          elsif line.split(",")[0] =~ /\s*\d\d:\d\d:\d\d/ # 지출 내역이 시:분:초를 포함한다
            exp = current_date.strip << " " << line.split(",")[0].strip << "," + line.split(",")[1..-1].map(&:strip).join(",")
          end
          exps << exp
        end
      end

      exps
    end

    def back_to_db_form(exps)
      result = ""
      exps.group_by { |exp| exp.at }.transform_values do |exp_group|
        result += "#{exp_group[0].at.strftime("%m/%d").sub(/^0/,'').sub(/\/0/,'/')}\n"
        exp_group.each do |exp|
          if exp.detail != nil
            result += "#{exp.amount},#{exp.category}.#{exp.detail}\n"
          else
            result += "#{exp.amount},#{exp.category}\n"
          end
        end
      end
      result
    end
  end
end
