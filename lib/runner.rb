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
    option_name, params = @option[0], @option[1..-1]

    puts @fm_reporter.print_report *params
  end

  def parse_run_option(argv)
    raw_expenses = ''
    # 항상 파일로부터 가계부 정보를 가져온다
    raw_expenses = File.read("../ledger/#{argv[argv.length - 1]}")
    expenses = @fm_reader.create_expense_list(raw_expenses)

    return ['ignore', expenses]
  end
end

