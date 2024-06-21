require_relative "../lib/runner"

RSpec.describe Runner, "runner" do
  it "can prepare run option" do
    default_rn = Runner.new(["2024_5"])
    default_rn.option.slice!(-1)
    expect(default_rn.option).to eq(["ignore"])
  end
end
