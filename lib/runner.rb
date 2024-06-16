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
    raw_monthly_expenses = read_expense
    monthly_expenses = @fm_reader.create_expense_list(raw_monthly_expenses)

    case @option.first
    when "--sum", "-s"
      puts @fm_reporter.compute_total_expense monthly_expenses
    when "--list", "-l"
      puts @fm_reporter.print_report monthly_expenses
    when "--filter", "-f"
      #TODO implement filter function
    else
      puts @fm_reporter.print_report monthly_expenses
    end
  end

  def read_expense
    if @option.first.start_with? "-"
      File.read("../ledger/#{@option[1]}")
    else
      File.read("../ledger/#{@option.first}")
    end
  end
end
