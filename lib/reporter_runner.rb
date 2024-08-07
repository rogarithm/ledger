require_relative "./expense"
require_relative "./expense_reader"
require_relative "./expense_reporter"
require_relative "./expense_filter"

class ReporterRunner
  UPPER_CAT_PATH = "./cat"

  attr_reader :reader, :reporter, :filter, :option

  def initialize(argv)
    @reader = ExpenseReader.new
    @reporter = ExpenseReporter.new
    @filter = ExpenseFilter.new
    @option = parse_run_option(argv)
  end

  def run
    option_name, params = @option[0], @option[1..-1]

    case option_name
    when "--sum", "-s"
      puts @reporter.compute_total_expense *params
    when "--sum-by-cat", "-cs"
      categories = @reporter.category_list *params
      sums = []
      categories.each do |category|
        cat_expenses = @filter.in_category category, *params
        sums << "#{category}...#{@reporter.sum_by_cat(cat_expenses, category)}"
      end
      puts sums.join("\n")
    when "--sum-by-upper-cat", "-ucs"
      upper_cat = load(File.readlines(UPPER_CAT_PATH).join(""))
      categories = @reporter.category_list *params
      categories.each do |category|
        cat_expenses = @filter.in_category category, *params
        upper_cat.keys.each do |key|
          if upper_cat[key].include? category
            cat_at = upper_cat[key].find_index category
            upper_cat[key][cat_at] = "#{category}:#{@reporter.sum_by_cat(cat_expenses, category)}"
          end
        end
      end
      puts upper_cat
    when "--list-by-cat", "-cl"
      categories = @reporter.category_list *params
      categories.each do |category|
        cat_expenses = @filter.in_category category, *params
        puts @reporter.report_by_cat cat_expenses, category
      end
    else
      puts @reporter.print_report *params
    end
  end

  def load aStream
    instance_eval aStream
  end

  def parse_run_option(argv)
    raw_expenses = ''
    # 항상 이전 실행 결과로부터 가계부 정보를 가져온다
    $stdin.each_line do |expense_txt|
      raw_expenses += expense_txt
    end
    expenses = @reader.read_expense_list(raw_expenses)

    option_name = argv.first
    return [option_name, expenses]
  end
end

