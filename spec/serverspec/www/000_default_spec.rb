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

describe user "trombik" do
  it { should exist }
  it { should belong_to_primary_group "wheel" }
  it { should belong_to_group "dialer" }
  it { should have_login_shell "/usr/local/bin/zsh" }
end

describe file "/home/trombik/.ssh/authorized_keys" do
  it { should exist }
  its(:content) { should match(/^ssh-rsa /) }
  its(:content) { should match(/y@trombik.org$/) }
end

describe file "/var/www/htdocs/sites" do
  it { should be_directory }
  it { should be_owned_by "trombik" }
  it { should be_grouped_into "www" }
  it { should be_mode 755 }
end

describe command "curl --output - -q -H 'Host: demo.i.trombik.org' http://127.0.0.1" do
  its(:stdout) { should match(/<title>Coming Soon - Start Bootstrap Theme/) }
end
