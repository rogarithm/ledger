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
    if ARGV.length > 1
      puts "more input than expected!"
      puts "exit..."
      return
    end

    raw_monthly_expenses = File.read("../ledger/#{ARGV[0]}")

    monthly_expenses = @fm_reader.create_expense_list(raw_monthly_expenses)

    puts @fm_reporter.compute_total_expense monthly_expenses
    puts @fm_reporter.print_report monthly_expenses
  end
end
