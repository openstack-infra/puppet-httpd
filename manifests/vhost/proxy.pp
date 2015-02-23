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
    $servername    = '',
    $serveraliases = '',
    $ssl           = false,
    $vhost_name    = '*'
  ) {

  include httpd

  $apache_name = $httpd::params::apache_name
  $ssl_path = $httpd::params::ssl_path
  $srvname = $name

  if $ssl == true {
    include httpd::ssl
  }

  file { "${priority}-${name}":
    path    => "${httpd::params::vdir}/${priority}-${name}",
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }


}
