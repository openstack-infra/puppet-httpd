require 'spec_helper_acceptance'

describe 'required packages' do
  describe 'RedHat packages', :if => ['fedora', 'redhat'].include?(os[:family]) do
    required_packages = [
      package('httpd'),
      package('httpd-devel'),
      package('php'),
      package('mod_python'),
      package('mod_python'),
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
