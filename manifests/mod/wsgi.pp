# Class: httpd::mod::wsgi
#
# This class installs wsgi for Apache
#
# Parameters:
#
# Actions:
# - Install Apache wsgi package
# - Enable mod_wsgi when on Debian or Ubuntu
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

  if $::osfamily == 'Debian' {
    httpd_mod { 'wsgi': ensure => present; }
  }
}
