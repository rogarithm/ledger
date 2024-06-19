require_relative "./expense"
require_relative "./expense_reader"
require_relative "./expense_reporter"

class Runner
  attr_reader :fm_reader, :fm_reporter, :option

  def initialize(argv)
    @fm_reader = ExpenseReader.new
    @fm_reporter = ExpenseReporter.new
    @option = parse_run_option(argv)
  end

  def run
    option_name = @option.first
    @option.shift
    params = @option

    case option_name
    when "--sum", "-s"
      puts @fm_reporter.compute_total_expense *params
    when "--range", "-r"
      puts @fm_reporter.back_to_db_form @fm_reporter.list_in_range *params
    when "--filter", "-f"
      method_name = :"#{params[0]}_than_amount"
      params.shift
      puts @fm_reporter.back_to_db_form @fm_reporter.send(method_name, *params)
    else
      puts @fm_reporter.print_report *params
    end
  end

  def parse_run_option(argv)
    raw_expenses = ''
    if argv.first == "xargs"
      # 파일 대신 이전 실행 결과로부터 가계부 정보를 가져오는 경우
      $stdin.each_line do |expense_txt|
        raw_expenses += expense_txt
      end

      # xargs는 파이핑 여부를 표시하기 위한 목적이므로 더 이상 필요없다
      argv.shift(1)
    else
      # 파일로부터 가계부 정보를 가져오는 경우
      raw_expenses = File.read("../ledger/#{argv[argv.length - 1]}")
    end
    expenses = @fm_reader.create_expense_list(raw_expenses)

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

    if argv.first.start_with? "-"
      option_name = argv.first

      return [option_name, expenses]
    end

    if argv.first.start_with?("-") == false
      file_name = argv.first

      [file_name, expenses]
    end
  end
end
