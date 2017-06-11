require 'spec_helper_acceptance'

describe 'puppet-httpd module' do
  def pp_path
    base_path = File.dirname(__FILE__)
    File.join(base_path, 'fixtures')
  end

  def default_puppet_module
    module_path = File.join(pp_path, 'default.pp')
    File.read(module_path)
  end

  it 'should work with no errors' do
    apply_manifest(default_puppet_module, catch_failures: true)
  end

  it 'should be idempotent', :if => ['debian', 'ubuntu'].include?(os[:family]) do
    apply_manifest(default_puppet_module, catch_changes: true)
  end

  it 'should be idempotent', :if => ['fedora', 'redhat'].include?(os[:family]) do
    pending('this module is not idempotent on CentOS yet')
    apply_manifest(default_puppet_module, catch_changes: true)
  end

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

      describe command('curl --verbose -H "Host: proxy" http://localhost/acceptance.txt') do
        its(:stdout) { should include 'Acceptance Test' }
      end

      describe command('curl --verbose -H "Host: redirect" http://localhost') do
        its(:stdout) { should include '302' }
        its(:stdout) { should include 'http://localhost:8080/acceptance.txt' }
      end
    end
  end
end
