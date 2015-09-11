require 'spec_helper_acceptance'

describe 'required services' do
  describe service('httpd'), :if => ['fedora', 'redhat'].include?(os[:family]) do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('apache2'), :if => ['debian', 'ubuntu'].include?(os[:family]) do
    it { should be_enabled }
    it { should be_running }
  end

  describe command('a2query -m ssl'), :if => ['debian', 'ubuntu'].include?(os[:family]) do
    its(:stdout) { should match 'enabled' }
  end
end
