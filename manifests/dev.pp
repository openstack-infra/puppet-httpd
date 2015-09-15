# Class: httpd::dev
#
# This class installs Apache development libraries
#
# Parameters:
#
# Actions:
#   - Install Apache development libraries
#
# Requires:
#
# Sample Usage:
#
class httpd::dev {
  include ::httpd::params

  package { $httpd::params::apache_dev:
    ensure => installed,
  }
}
