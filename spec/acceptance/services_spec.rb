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

  describe 'vhosts' do
    describe command('curl --verbose http://localhost') do
      its(:stdout) { should include 'Index of /' }
    end

    describe command('curl --verbose -H "Host: openstack-proxy" http://localhost') do
      its(:stdout) { should include 'https://review.openstack.org' }
    end

    describe command('curl --verbose -H "Host: openstack-redirect" http://localhost') do
      its(:stdout) { should include '302' }
      its(:stdout) { should include 'http://www.openstack.org' }
    end
  end
end
