require_relative "../lib/ledger/reservedlist"
require_relative "./helper/spec_helper"

describe Lgr::Preproc do
  RSpec.configure do |config|
    config.filter_run_when_matching(focus: true)
    config.example_status_persistence_file_path = 'spec/pass_fail_history'
  end

  it "예약 지출 정보를 불러올 수 있다" do
    reservedlist = Lgr::ReservedList.new(
      File.read(File.join(File.dirname(__FILE__), *%w[data before reserved_savings]))
    )
    expect(reservedlist).to eq(["i:x/5:5:s", "j:x/5:30:m", "z:x/26:2:s"])
  end

  it "예약 지출 정보를 가계부에 추가할 수 있는 형태로 바꿀 수 있다" do
    reservedlist = Lgr::ReservedList.new(
      "i:x/5:5:s\nj:x/5:30:m\nz:x/26:2:s"
    )
    p reservedlist.convert2ledger(8)
  end

  fit "예약 지출 내역을 가계부에 추가할 수 있다" do
    reservedlist = Lgr::ReservedList.new(
      "i:x/5:5:s\nj:x/5:30:m\nz:x/26:2:s"
    )

    File.open(File.join(File.dirname(__FILE__), *%w[data after reserved_savings]), 'w') do |f|
      f << "dummy!\n"
    end

    File.open(File.join(File.dirname(__FILE__), *%w[data after reserved_savings]), 'a') do |f|
      reservedlist.convert2ledger(8).each do |rsv|
        f << rsv
      end
    end
  end
end

