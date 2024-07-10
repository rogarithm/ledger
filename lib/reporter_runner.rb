require_relative "./expense"
require_relative "./expense_reader"
require_relative "./expense_reporter"
require_relative "./expense_filter"

class ReporterRunner
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
    when "--report-by-category", "-rbc"
      categories = @reporter.category_list *params
      sums = []
      categories.each do |category|
        cat_expenses = @filter.in_category category, *params
        sums << @reporter.sum_by_cat(cat_expenses, category)
      end
      puts sums.join("\n")

      categories.each do |category|
        cat_expenses = @filter.in_category category, *params
        puts @reporter.report_by_cat cat_expenses, category
      end
    else
      puts @reporter.print_report *params
    end
  end

  def parse_run_option(argv)
    raw_expenses = ''
    # 항상 이전 실행 결과로부터 가계부 정보를 가져온다
    $stdin.each_line do |expense_txt|
      raw_expenses += expense_txt
    end
    expenses = @reader.read_expense_list(raw_expenses)

    # request to printer
    if argv.first == nil
      return ['ignore', expenses]
    end

    if argv.first == "--report-by-category" or argv.first == "-rbc"
      option_name = argv.first

      return [option_name, expenses]
    end

    option_name = argv.first
    return [option_name, expenses]
  end
end

