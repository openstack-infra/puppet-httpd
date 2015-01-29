# Class: httpd::python
#
# This class installs Python for Apache
#
# Parameters:
# - $php_package
#
# Actions:
#   - Install Apache Python package
#
# Requires:
#
# Sample Usage:
#
class httpd::python {
  include httpd::params
  include httpd

  package { 'apache_python_package':
    ensure => present,
    name   => $apache::params::python_package,
  }
  httpd_mod { 'python': ensure => present, }

}
