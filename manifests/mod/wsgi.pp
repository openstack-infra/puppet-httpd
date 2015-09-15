# Class: httpd::mod::wsgi
#
# This class installs wsgi for Apache
#
# Parameters:
#
# Actions:
# - Install Apache wsgi package
#
# Requires:
#
# Sample Usage:
#
class httpd::mod::wsgi {
  include ::httpd

  package { 'mod_wsgi_package':
    ensure  => installed,
    name    => $httpd::params::mod_wsgi_package,
    require => Package['httpd'];
  }

  httpd::mod { 'wsgi': ensure => present; }

}

