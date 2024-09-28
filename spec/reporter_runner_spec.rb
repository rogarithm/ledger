require_relative "../lib/reporter_runner"

RSpec.describe ReporterRunner, "runner" do
  it "실행 옵션을 설정할 수 있다" do
    # 항상 표준 입력으로부터 가계부 데이터를 받는 것을 가정한다
    $stdin = "4/2\n4,b.m\n1,v.ns\n"

    report_cat_rn = ReporterRunner.new(["--category", "2024_5"])
    report_cat_rn.option.slice!(-1)
    expect(report_cat_rn.option).to eq(["--category"])
  end
end


