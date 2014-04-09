require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "Logstash Agent" do

  it "has a running service of logstash" do
    expect(service("logstash")).to be_running
  end

end