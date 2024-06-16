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
      puts @fm_reporter.list_in_range *params
    when "--filter", "-f"
      #TODO implement filter function
    else
      puts @fm_reporter.print_report *params
    end
  end

  def parse_run_option(argv)
    if argv.first == "--range" or argv.first == "-r"
      option_name = argv.first
      from = argv[1]
      to = argv[2]

      argv.shift(3)

      raw_expenses = File.read("../ledger/#{argv[0]}")
      expenses = @fm_reader.create_expense_list(raw_expenses)
      return [option_name, from, to, expenses]
    end

    if argv.first.start_with? "-"
      option_name = argv.first

      argv.shift(1)

      raw_expenses = File.read("../ledger/#{argv[0]}")
      expenses = @fm_reader.create_expense_list(raw_expenses)
      return [option_name, expenses]
    end

    if argv.first.start_with?("-") == false
      file_name = argv.first

      argv.shift(1)

      raw_expenses = File.read("../ledger/#{file_name}")
      expenses = @fm_reader.create_expense_list(raw_expenses)
      [file_name, expenses]
    end
  end
end
