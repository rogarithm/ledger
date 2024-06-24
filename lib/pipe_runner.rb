require_relative "./expense"
require_relative "./expense_reader"
require_relative "./expense_reporter"
require_relative "./expense_filter"

class PipeRunner
  attr_reader :fm_reader, :fm_reporter, :fm_filter, :option

  def initialize(argv)
    @fm_reader = ExpenseReader.new
    @fm_reporter = ExpenseReporter.new
    @fm_filter = ExpenseFilter.new
    @option = parse_run_option(argv)
  end

  def run
    option_name, params = @option[0], @option[1..-1]

    case option_name
    when "--sum", "-s"
      puts @fm_reporter.compute_total_expense *params
    when "--range", "-r"
      puts @fm_reporter.back_to_db_form @fm_filter.list_in_range *params
    when "--filter", "-f"
      method_name = :"#{params[0]}_than_amount"
      params.shift
      puts @fm_reporter.back_to_db_form @fm_filter.send(method_name, *params)
    when "--category", "-c"
      puts @fm_reporter.back_to_db_form @fm_filter.in_category *params
    else
      puts @fm_reporter.print_report *params
    end
  end

  def parse_run_option(argv)
    raw_expenses = ''
    # 항상 이전 실행 결과로부터 가계부 정보를 가져온다
    $stdin.each_line do |expense_txt|
      raw_expenses += expense_txt
    end
    expenses = @fm_reader.create_expense_list(raw_expenses)

    # request to printer
    if argv.first == nil
      return ['ignore', expenses]
    end

    # request to filter
    if argv.first == "--range" or argv.first == "-r"
      option_name = argv.first
      from = argv[1]
      to = argv[2]

      return [option_name, from, to, expenses]
    end

    # request to filter
    if argv.first == "--filter" or argv.first == "-f"
      option_name = argv.first
      filter_name = argv[1]
      bound_amount = argv[2].to_i

      return [option_name, filter_name, bound_amount, expenses]
    end

    if argv.first == "--category" or argv.first == "-c"
      option_name = argv.first
      category_name = argv[1]

      return [option_name, category_name, expenses]
    end

    option_name = argv.first
    return [option_name, expenses]
  end
end

