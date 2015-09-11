# Class: httpd::mod::python
#
# This class installs Python for Apache
#
# Parameters:
#
# Actions:
# - Install Apache Python package
#
# Requires:
#
# Sample Usage:
#
class httpd::mod::python {
  include ::httpd
  include ::httpd::mod

  package { 'mod_python_package':
    ensure  => installed,
    name    => $httpd::params::mod_python_package,
    require => Package['httpd'];
  }

  httpd::mod { 'python': ensure => present; }

}


