require_relative "./expense"
require_relative "./expense_reader"
require_relative "./expense_reporter"

class Runner
  attr_reader :option, :fm_reader, :fm_reporter

  def initialize(argv)
    @option = argv
    @fm_reader = ExpenseReader.new
    @fm_reporter = ExpenseReporter.new
  end

  def run
    raw_expenses = read_expense
    expenses = @fm_reader.create_expense_list(raw_expenses)

    case @option.first
    when "--sum", "-s"
      puts @fm_reporter.compute_total_expense expenses
    when "--range", "-r"
      from = @option[1]
      to = @option[2]
      puts @fm_reporter.list_in_range from, to, expenses
    when "--filter", "-f"
      #TODO implement filter function
    else
      puts @fm_reporter.print_report expenses
    end
  end

  def read_expense
    if @option.first == "--range" or @option.first == "-r"
      File.read("../ledger/#{@option[3]}")
    elsif @option.first.start_with? "-"
      File.read("../ledger/#{@option[1]}")
    else
      File.read("../ledger/#{@option.first}")
    end
  end
end
