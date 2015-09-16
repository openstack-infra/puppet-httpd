# Class: httpd::mod::python
#
# This class installs Python for Apache
# Please use httpd::mod::wsgi for CentOS >= 7 as mod_python is officially deprecated.
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

  package { 'mod_python_package':
    ensure  => installed,
    name    => $httpd::params::mod_python_package,
    require => Package['httpd'];
  }

  httpd::mod { 'python': ensure => present; }

}


