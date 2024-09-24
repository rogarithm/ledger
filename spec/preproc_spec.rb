require_relative "../lib/ledger/preproc"
require_relative "./helper/spec_helper"

describe Lgr::Preproc do
  RSpec.configure do |config|
    config.filter_run_when_matching(focus: true)
    config.example_status_persistence_file_path = 'spec/pass_fail_history'
  end

  TEST_DATA_DIR = File.join(File.dirname(__FILE__), *%w[data])

  before(:each) do
    @pp = Lgr::Preproc.new
  end

  it "계좌명을 지운다" do
    src_path = File.join(TEST_DATA_DIR, *%w[before remove_account])

    rm_acc = Lgr::Ledger.new(File.read(src_path)).ignore_account_lines
    rm_acc.split("\n").each do |l|
      expect(l).to match(/^\s+.*/)
    end
  end

  it "지출 성격과 날짜를 기준으로 지출 내역을 모은다. 지출 내역에 계좌 정보를 포함한다" do
    src_path_sp = File.join(TEST_DATA_DIR, *%w[before group_with_acc_simple])

    mid_res_sp = {:fix_exp => {"8/5" => ["7,x,shinhan"], "8/26" => ["3,d,kakao"]}}
    expect(@pp.group_by_exp_type(File.read(src_path_sp))).to eq(mid_res_sp)

    res_path_sp = File.join(TEST_DATA_DIR, *%w[after group_with_acc_simple])
    expected_sp = File.read(res_path_sp)
    expect(@pp.back2ledger_form(mid_res_sp)).to eq_ignore_ws(expected_sp)

    src_path_cpx = File.join(TEST_DATA_DIR, *%w[before group_with_acc_complex])
    mid_res_cpx = @pp.group_by_exp_type(File.read(src_path_cpx))

    res_path_cpx = File.join(TEST_DATA_DIR, *%w[after group_with_acc_complex])
    expected_cpx = File.read(res_path_cpx)
    expect(@pp.back2ledger_form(mid_res_cpx)).to eq_ignore_ws(expected_cpx)
  end

  it "지출 성격과 날짜를 기준으로 지출 내역을 모은다" do
    src_path_sp = File.join(TEST_DATA_DIR, *%w[before group_by_exp_type_simple])

    mid_res_sp = {:fix_exp => {"8/5" => ["7,b"], "8/26" => ["3,c"]}}
    expect(@pp.group_by_exp_type(File.read(src_path_sp))).to eq(mid_res_sp)

    res_path_sp = File.join(TEST_DATA_DIR, *%w[after group_by_exp_type_simple])
    expected_sp = File.read(res_path_sp)
    expect(@pp.back2ledger_form(mid_res_sp)).to eq_ignore_ws(expected_sp)

    src_path_cpx = File.join(TEST_DATA_DIR, *%w[before group_by_exp_type_complex])
    mid_res_cpx = @pp.group_by_exp_type(File.read(src_path_cpx))

    res_path_cpx = File.join(TEST_DATA_DIR, *%w[after group_by_exp_type_complex])
    expected_cpx = File.read(res_path_cpx)
    expect(@pp.back2ledger_form(mid_res_cpx)).to eq_ignore_ws(expected_cpx)
  end

  it "지출 월을 알아낼 수 있다" do
    date_n_exps = {"7/31"=>["-20,i"], "8/9"=>["-7,tc"], "8/26"=>["-8,cb"], "8/12"=>["-7,c"]}
    expect(@pp.find_month(date_n_exps)).to eq("8")
  end

  it "지출 성격마다 분리한다" do
    res = @pp.split_by_exp_type(
      "fix_exp\n8/5\n7,b\n8/26\n3,c\n"
    )

    expect(res).to eq({
      "fix_exp:2024_8" => "8/5\n7,b\n8/26\n3,c"
    })
  end

  it "보기 편하게 지출 내역을 포맷팅한다" do
    date_n_exps_list = ["8/5\n7,b\n8/26\n3,c\n", "8/1\n-70,b\n8/2\n-30,c\n"]
    pretty_date_n_exps_list = []
    date_n_exps_list.each do |date_n_exps|
      pretty_date_n_exps_list << @pp.pretty_format(date_n_exps)
    end

    expect(pretty_date_n_exps_list).to pretty_formatted
  end

  it "지출 성격별로 저장한다" do
    ledgers = {
      "after/split/fix_exp:2023_8" => "8/5\n7,b\n8/26\n3,c\n",
      "after/split/income:2023_8" => "8/1\n-70,b\n8/2\n-30,c\n"
    }

    @pp.make(ledgers, "../spec/data", false)
    expect(File.exist?(File.join(TEST_DATA_DIR, "after/split/fix_exp/2023_8"))).to be true
    expect(File.exist?(File.join(TEST_DATA_DIR, "after/split/income/2023_8"))).to be true
  end
end
