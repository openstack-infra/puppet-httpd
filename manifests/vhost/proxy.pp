# Define: httpd::vhost::proxy
#
# Configures an apache vhost that will only proxy requests
#
# Parameters:
# * $port:
#     The port on which the vhost will respond
# * $dest:
#     URI that the requests will be proxied for
# - $priority
# - $template -- the template to use for the vhost
# - $vhost_name - the name to use for the vhost, defaults to '*'
#
# Actions:
# * Install Apache Virtual Host
#
# Requires:
#
# Sample Usage:
#
define httpd::vhost::proxy (
    $dest,
    $port,
    $docroot         = undef,
    $priority        = '10',
    $proxyexclusions = undef,
    $serveraliases   = undef,
    $servername      = undef,
    $ssl             = false,
    $template        = 'httpd/vhost-proxy.conf.erb',
    $vhost_name      = '*',
  ) {

  include ::httpd

  $apache_name = $httpd::params::apache_name
  $ssl_path = $httpd::params::ssl_path
  if $servername == undef {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  if $ssl == true {
    include ::httpd::ssl
  }

  # The Apache mod_version module only needs to be enabled on Ubuntu 12.04
  # as it comes compiled and enabled by default on newer OS, including CentOS
  if !defined(Httpd::Mod['version']) and $::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '12.04' {
    httpd::mod { 'version': ensure => present }
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

  # enable that setting, that allows httpd scripts and
  # modules to connect to the network
  if $::osfamily == 'RedHat' {
    selinux::boolean { 'httpd_can_network_connect':
      ensure => 'on',
    }
  }
}
