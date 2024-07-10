require_relative "../lib/reporter_runner"

RSpec.describe ReporterRunner, "runner" do
  it "can prepare run option" do
    # 항상 표준 입력으로부터 가계부 데이터를 받는 것을 가정한다
    $stdin = "4/2\n4100,아침.맥모닝\n1000,여가.네이버 시리즈\n"

    report_cat_rn = ReporterRunner.new(["--report-by-category", "2024_5"])
    report_cat_rn.option.slice!(-1)
    expect(report_cat_rn.option).to eq(["--report-by-category"])
  end
end


