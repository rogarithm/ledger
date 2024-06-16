require_relative "../lib/runner"

RSpec.describe Runner, "runner" do
  it "can prepare run option" do
    sum_rn = Runner.new(["--sum", "2024_5"])
    sum_rn.option.slice!(-1)
    expect(sum_rn.option).to eq(["--sum"])

    range_rn = Runner.new(["--range", "4/2", "4/4", "2024_5"])
    range_rn.option.slice!(-1)
    expect(range_rn.option).to eq(["--range", "4/2", "4/4"])

    filter_rn = Runner.new(["--filter", "2024_5"])
    filter_rn.option.slice!(-1)
    expect(filter_rn.option).to eq(["--filter"])

    default_rn = Runner.new(["2024_5"])
    default_rn.option.slice!(-1)
    expect(default_rn.option).to eq(["2024_5"])
  end
end
