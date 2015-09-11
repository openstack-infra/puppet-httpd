require 'spec_helper_acceptance'

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
  end
end
