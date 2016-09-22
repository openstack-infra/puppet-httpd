# Define: httpd::vhost::redirect
#
# This class will create a vhost that does nothing more than redirect to a
# given location
#
# Parameters:
#   $port:
#       Which port to list on
#   $dest:
#       Where to redirect to
# - $vhost_name
#
# Actions:
#   Installs apache and creates a vhost
#
# Requires:
#
# Sample Usage:
#
define httpd::vhost::redirect (
    $port,
    $dest,
    $priority      = '10',
    $serveraliases = $httpd::params::serveraliases,
    $servername    = $httpd::params::servername,
    $serveradmin   = $httpd::params::serveradmin,
    $template      = 'httpd/vhost-redirect.conf.erb',
    $vhost_name    = $httpd::params::vhost_name,
  ) {

  include ::httpd

  if $servername == undef {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  file { "${priority}-${name}":
    ensure => absent,
    path   => "${httpd::params::vdir}/${priority}-${name}",
  }

  file { "${priority}-${name}.conf":
    path    => "${httpd::params::vdir}/${priority}-${name}.conf",
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }

  if ! defined(Firewall["0100-INPUT ACCEPT ${port}"]) {
    @firewall {
      "0100-INPUT ACCEPT ${port}":
        jump  => 'ACCEPT',
        dport => '$port',
        proto => 'tcp'
    }
  }
}

