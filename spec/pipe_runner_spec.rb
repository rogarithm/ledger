require_relative "../lib/pipe_runner"

RSpec.describe PipeRunner, "runner" do
  it "실행 옵션을 설정할 수 있다" do
    # 항상 표준 입력으로부터 가계부 데이터를 받는 것을 가정한다
    $stdin = "4/2\n4,b.m\n1,v.ns\n"

    range_rn = PipeRunner.new(["--range", "4/2", "4/4", "2024_5"])
    range_rn.option.slice!(-1)
    expect(range_rn.option).to eq(["--range", "4/2", "4/4"])

    filter_rn = PipeRunner.new(["--filter", "ge", "2", "2024_5"])
    filter_rn.option.slice!(-1)
    expect(filter_rn.option).to eq(["--filter", "ge", 2])

    default_rn = PipeRunner.new(["2024_5"])
    default_rn.option.slice!(-1)
    expect(default_rn.option).to eq(["2024_5"])
  end
end

