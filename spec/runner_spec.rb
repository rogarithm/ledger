require_relative "../lib/runner"

RSpec.describe Runner, "runner" do
  it "can parse options" do
    rn = Runner.new(["--sum", "2024_5"])
    expect(rn.option).to eq(["--sum", "2024_5"])
  end
end
