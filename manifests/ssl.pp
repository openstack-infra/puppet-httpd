# Class: httpd::ssl
#
# This class installs Apache SSL capabilities
#
# Parameters:
# - The $ssl_package name from the apache::params class
#
# Actions:
#   - Install Apache SSL capabilities
#
# Requires:
#
# Sample Usage:
#
class httpd::ssl {

  include ::httpd

  case $::operatingsystem {
    'centos', 'fedora', 'redhat', 'scientific': {
      package { 'apache_ssl_package':
        ensure  => installed,
        name    => $httpd::params::ssl_package,
        require => Package['httpd'],
      }
    }
    'ubuntu', 'debian': {
      httpd::mod { 'ssl': ensure => present, }
    }
    default: {
      fail( "${::operatingsystem} not defined in httpd::ssl.")
    }
  }

  if $::lsbdistcodename == 'precise' {
    # Unconditionally enable SNI on Ubuntu 12.04 (it's on by default in 14.04)
    file { '/etc/apache2/conf.d/sni':
      ensure  => present,
      source  => 'puppet:///modules/httpd/sni',
      notify  => Service['httpd'],
      require => Package['httpd'],
    }
  }
}
