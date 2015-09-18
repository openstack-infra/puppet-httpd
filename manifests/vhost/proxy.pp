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
    $port,
    $dest,
    $priority      = '10',
    $template      = 'httpd/vhost-proxy.conf.erb',
    $servername    = undef,
    $serveraliases = undef,
    $ssl           = false,
    $vhost_name    = '*'
  ) {

  include ::httpd

  if (!defined(Httpd::Mod['proxy'])) {
    httpd::mod { 'proxy': ensure => present; }
  }
  if (!defined(Httpd::Mod['proxy_http'])) {
    httpd::mod { 'proxy_http': ensure => present; }
  }

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

  file { "${priority}-${name}.conf":
    path    => "${httpd::params::vdir}/${priority}-${name}.conf",
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }


}
