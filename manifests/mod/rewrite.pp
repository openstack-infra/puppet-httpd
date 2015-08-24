# Class: httpd::mod::rewrite
#
# This class installs rewrite for Apache
#
# Parameters:
#
# Actions:
# - Enable mod_rewrite when on Debian or Ubuntu
#
# Requires:
#
# Sample Usage:
#
class httpd::mod::rewrite {

  if $::osfamily == 'Debian' {
    httpd_mod { 'rewrite': ensure => present; }
  }
}
