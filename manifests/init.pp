# Class: httpd
#
# This class installs Apache
#
# Parameters:
#
# Actions:
#   - Install Apache
#   - Manage Apache service
#
# Requires:
#
# Sample Usage:
#
class httpd {
  include ::httpd::params

  package { 'httpd':
    ensure => installed,
    name   => $httpd::params::apache_name,
  }

  service { 'httpd':
    ensure    => running,
    name      => $httpd::params::apache_name,
    enable    => true,
    subscribe => Package['httpd'],
  }

  file { 'httpd_vdir':
    ensure  => directory,
    path    => $httpd::params::vdir,
    recurse => true,
    purge   => true,
    notify  => Service['httpd'],
    require => Package['httpd'],
  }
}
