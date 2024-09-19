require_relative "./ledger/expense"
require_relative "./ledger/expense_reader"
require_relative "./ledger/expense_filter"

class PipeRunner
  attr_reader :reader, :filter, :option

  def initialize(argv)
    @reader = Lgr::ExpenseReader.new
    @filter = Lgr::ExpenseFilter.new
    @option = parse_run_option(argv)
  end

  def run
    option_name, params = @option[0], @option[1..-1]

    case option_name
    when "--range", "-r"
      puts @reader.back_to_db_form @filter.list_in_range *params
    when "--filter", "-f"
      method_name = :"#{params[0]}_than_amount"
      params.shift
      puts @reader.back_to_db_form @filter.send(method_name, *params)
    when "--category", "-c"
      puts @reader.back_to_db_form @filter.in_category *params
    else
      puts @reader.back_to_db_form *params # 필터링 없이 보여준다
    end
  end

  def parse_run_option(argv)
    raw_expenses = ''
    # 항상 이전 실행 결과로부터 가계부 정보를 가져온다
    $stdin.each_line do |expense_txt|
      raw_expenses += expense_txt
    end
    expenses = @reader.read_expense_list(raw_expenses)

    if argv.first == "--range" or argv.first == "-r"
      option_name = argv.first
      from = argv[1]
      to = argv[2]

      return [option_name, from, to, expenses]
    end

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

