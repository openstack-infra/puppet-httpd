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

  describe 'required files' do
    describe 'RedHat files', :if => ['fedora', 'redhat'].include?(os[:family]) do
      describe file('/etc/httpd/conf.d/') do
        it { should be_directory }
      end

      describe file('/etc/httpd/conf.d/50-localhost.conf') do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        its(:content) { should include '<VirtualHost *:80>' }
      end
    end

    describe 'Debian files', :if => ['debian', 'ubuntu'].include?(os[:family]) do
      describe file('/etc/apache2/sites-enabled/') do
        it { should be_directory }
      end

      describe file('/etc/apache2/sites-enabled/50-localhost.conf') do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        its(:content) { should include '<VirtualHost *:80>' }
      end

      describe file('/etc/apache2/mods-enabled/python.load') do
        it { should be_linked_to '../mods-available/python.load' }
      end

      describe file('/etc/apache2/mods-enabled/ssl.load') do
        it { should be_linked_to '../mods-available/ssl.load' }
      end

      describe file('/etc/apache2/mods-enabled/rewrite.load') do
        it { should be_linked_to '../mods-available/rewrite.load' }
      end
    end
  end

  describe 'required packages' do
    describe 'RedHat packages', :if => ['fedora', 'redhat'].include?(os[:family]) do
      required_packages = [
        package('httpd'),
        package('httpd-devel'),
        package('php'),
        package('mod_ssl'),
      ]

      required_packages.each do |package|
        describe package do
          it { should be_installed }
        end
      end
    end

    describe 'Debian packages', :if => ['debian', 'ubuntu'].include?(os[:family]) do
      required_packages = [
        package('apache2'),
        package('apache2-dev'),
        package('libaprutil1-dev'),
        package('libapr1-dev'),
        package('libapache2-mod-php5'),
        package('libapache2-mod-python'),
      ]

      required_packages.each do |package|
        describe package do
          it { should be_installed }
        end
      end
    end
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
