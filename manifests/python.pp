# Class: httpd::python
#
# This class installs Python for Apache
# Please use httpd::mod::wsgi for CentOS >= 7 as mod_python is officially deprecated.
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
    name   => $httpd::params::mod_python_package,
  }
  httpd::mod { 'python': ensure => present, }

}
