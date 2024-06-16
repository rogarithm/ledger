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
    case option_name
    when "--sum", "-s"
      puts @fm_reporter.compute_total_expense *@option
    when "--range", "-r"
      puts @fm_reporter.list_in_range *@option
    when "--filter", "-f"
      #TODO implement filter function
    else
      puts @fm_reporter.print_report *@option
    end
  end

  def parse_run_option(argv)
    if argv.first == "--range" or argv.first == "-r"
      from = argv[1]
      to = argv[2]
      raw_expenses = File.read("../ledger/#{argv[3]}")
      expenses = @fm_reader.create_expense_list(raw_expenses)
      return [argv.first, from, to, expenses]
    end

    if argv.first.start_with? "-"
      raw_expenses = File.read("../ledger/#{argv[1]}")
      expenses = @fm_reader.create_expense_list(raw_expenses)
      return [argv.first, expenses]
    end

    if argv.first.start_with?("-") == false
      raw_expenses = File.read("../ledger/#{argv.first}")
      expenses = @fm_reader.create_expense_list(raw_expenses)
      [argv.first, expenses]
    end
  end
end
