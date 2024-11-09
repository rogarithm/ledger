require 'rake/clean'
require 'csv'
require_relative "./lib/ledger/preproc"
require_relative "./lib/ledger/expense"
require_relative "./lib/ledger/expense_reader"
require_relative "./lib/ledger/expenselist"

desc 'report'
task :report, [:month] => [:type_sum] do |igonre, args|
end

#usage: rake type_sum[9]
desc '지출성격별 합계를 구한다'
task :type_sum, [:month] do |ignore, args|
  output_file = File.join(File.dirname(__FILE__), *%W[.. ledger dest report 2024_#{args[:month]}])
  exp_types = %w[income saving fix_exp var_exp]

  CSV.open(output_file, 'w') do |csv|
    csv << ["총계"] << ["지출성격", "지출금액"]
    exp_types.each do |exp_type|
      src_path = File.join(File.dirname(__FILE__), *%W[.. ledger dest #{exp_type} #{"2024_#{args[:month]}"}])
      er = Lgr::ExpenseReader.new
      explist = Lgr::ExpenseList.new(er.read_expense_list(File.read(src_path)))
      total = explist.compute_total_expense
      pretty_total = Lgr::Expense.new("1/1,#{total},x").format_amount
      csv << ["#{exp_type}","#{pretty_total}"]
    end
  end
end

  file_nm = "2024_#{args[:month]}"
  csv = []
  %w[income saving fix_exp var_exp].each do |exp_type|
    src_path = File.join(File.dirname(__FILE__), *%W[.. ledger dest #{exp_type} #{file_nm}])
    er = Lgr::ExpenseReader.new
    explist = Lgr::ExpenseList.new(er.read_expense_list(File.read(src_path)))
    csv << "#{exp_type}, #{explist.compute_total_expense}"
  end
  puts csv.join("\n")
end

desc 'sum by big categories'
task :cat_sum, [:month] do |ignore, args|
  file_nm = "2024_#{args[:month]}"
  %w[var_exp].each do |exp_type|
    src_path = File.join(File.dirname(__FILE__), *%W[.. ledger dest #{exp_type} #{file_nm}])
    er = Lgr::ExpenseReader.new
    explist = Lgr::ExpenseList.new(er.read_expense_list(File.read(src_path)))
    explist.category_list.each do |cat|
      puts "CAT: #{cat}"
      puts explist.in_category(cat)
    end
  end
end

task :prep, [:month] do |ignore, args|
  file_nm = "2024_#{args[:month]}"
  pp = Lgr::Preproc.new
  src_path = File.join(File.dirname(__FILE__), *%W[.. ledger source explist #{file_nm}])
  ignore_emp_lines = Lgr::Ledger.new(File.read(src_path))
                                      .ignore_empty_lines
  x = pp.split_by_exp_type(ignore_emp_lines, from_csv: true)
  pp.make(x, "../../ledger/dest")
end

task :rinse_kakao_csv, [:month] do |ignore, args|
  input_file = File.join(File.dirname(__FILE__), *%W[.. ledger source raw 2024_#{args[:month]} kakao.csv])  # Replace with your input CSV file path
  output_file = File.join(File.dirname(__FILE__), *%W[.. ledger source raw 2024_#{args[:month]} kakao_rinsed.csv])  # Replace with your desired output file path

  CSV.open(output_file, 'w') do |csv|
    csv << ['거래일시', '거래금액', '내용']

    CSV.foreach(input_file, headers: true) do |row|
      if !row['거래일시'] or !row['거래금액']
        next
      end

      row['거래일시'] = row['거래일시'][5..-1].gsub('.', '/')

      row['거래금액'] = row['거래금액'].gsub(',', '_')
      if row['거래금액'].to_i < 0
        row['거래금액'].sub!('-', '')
      else
        row['거래금액'] = "-#{row['거래금액']}"
      end

      csv << row.values_at('거래일시', '거래금액', '내용')
    end
  end

  puts "CSV processing complete! Output saved to #{output_file}"
end

task :rinse_shinhan_csv, [:month] do |ignore, args|
  input_file = File.join(File.dirname(__FILE__), *%W[.. ledger source raw 2024_#{args[:month]} shinhan.csv])  # Replace with your input CSV file path
  output_file = File.join(File.dirname(__FILE__), *%W[.. ledger source raw 2024_#{args[:month]} shinhan_rinsed.csv])  # Replace with your desired output file path

  CSV.open(output_file, 'w') do |csv|
    # Define the new header with '출금(원)' changed to '금액' and without '입금(원)'
    csv << ['거래일시', '거래금액', '내용']

    # Read the input CSV
    CSV.foreach(input_file, headers: true) do |row|
      if !row['거래일자'] or !row['거래시간']
        next
      end

      row['거래일자'] = row['거래일자'][5..9].gsub('-', '/')
      row['거래일시'] = "#{row['거래일자']} #{row['거래시간']}"
      # # 2. Remove unnecessary columns (third column: 적요 and eighth column: 거래점)
      # row.delete('적요')
      # row.delete('거래점')

      # 3. Merge columns for expense/income handling
      if row['출금(원)'].to_i > 0
        row['거래금액'] = row['출금(원)']
      elsif row['입금(원)'].to_i > 0
        row['거래금액'] = "-#{row['입금(원)']}"
      end

      row['거래금액'] = row['거래금액'].gsub(',', '_')

      csv << row.values_at('거래일시', '거래금액', '내용')
    end
  end

  puts "CSV processing complete! Output saved to #{output_file}"
end

task :rinse_toss_csv, [:month] do |ignore, args|
  input_file = File.join(File.dirname(__FILE__), *%W[.. ledger source raw 2024_#{args[:month]} toss.csv])  # Replace with your input CSV file path
  output_file = File.join(File.dirname(__FILE__), *%W[.. ledger source raw 2024_#{args[:month]} toss_rinsed.csv])  # Replace with your desired output file path

  CSV.open(output_file, 'w') do |csv|
    csv << ['거래일시', '거래금액', '내용']

    CSV.foreach(input_file, headers: true) do |row|
      if !row['거래 일시']
        next
      end

      row['거래일시'] = "#{row['거래 일시'][5..9].gsub('.', '/')}#{row['거래 일시'][10..-1].gsub('.', '/')}"

      row['거래 금액'] = row['거래 금액'].gsub(',', '_')
      if row['거래 금액'].to_i < 0
        row['거래금액'] = row['거래 금액'].sub!('-', '')
      else
        row['거래금액'] = "-#{row['거래 금액']}"
      end


      csv << row.values_at('거래일시', '거래금액', '적요')
    end
  end

  puts "CSV processing complete! Output saved to #{output_file}"
end
