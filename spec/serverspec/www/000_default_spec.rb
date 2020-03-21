require_relative "../spec_helper"

domain_name = "i.trombik.org"

describe "nex1" do
  it_behaves_like "a host with all basic tools installed"
end

describe command "date +%z" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/^\+0700$/) }
end

describe file "/etc/resolv.conf" do
  it { should be_file }
  its(:content) { should match(/^search #{domain_name}$/) }
end

describe command "ftp -o /dev/null -d http://localhost/" do
  its(:exit_status) { should_not eq 0 }
  its(:stdout) { should match(/^ftp: Error retrieving file: 410 Gone/) }
end
