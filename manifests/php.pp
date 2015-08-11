# Class: httpd::php
#
# This class installs PHP for Apache
#
# Parameters:
# - $php_package
#
# Actions:
#   - Install Apache PHP package
#
# Requires:
#
# Sample Usage:
#
class httpd::php {
  include ::httpd::params

  package { 'apache_php_package':
    ensure => present,
    name   => $httpd::params::php_package,
  }
}
