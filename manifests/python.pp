# Class: httpd::python
#
# This class installs Python for Apache
#
# Parameters:
# - $python_package
#
# Actions:
#   - Install Apache Python package
#
# Requires:
#
# Sample Usage:
#
class httpd::python {
  include ::httpd::params
  include ::httpd

  package { 'apache_python_package':
    ensure => present,
    name   => $apache::params::mod_python_package,
  }
  httpd::mod { 'python': ensure => present, }

}
