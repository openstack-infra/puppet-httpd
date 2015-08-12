# Definition: httpd::vhost
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - The $port to configure the host on
# - The $docroot provides the DocumentationRoot variable
# - The $ssl option is set true or false to enable SSL for this Virtual Host
# - The $configure_firewall option is set to true or false to specify if
#   a firewall should be configured.
# - The $template option specifies whether to use the default template or
#   override
# - The $priority of the site
# - The $serveraliases of the site
# - The $options for the given vhost
# - The $vhost_name for name based virtualhosting, defaulting to *
# - The $content of the vhost (overrides template)
#
# Actions:
# - Install Apache Virtual Hosts
#
# Requires:
# - The httpd class
#
# Sample Usage:
#  httpd::vhost { 'site.name.fqdn':
#    priority => '20',
#    port => '80',
#    docroot => '/path/to/docroot',
#  }
#
define httpd::vhost(
    $port,
    $docroot,
    $configure_firewall = true,
    $ssl                = $httpd::params::ssl,
    $template           = $httpd::params::template,
    $priority           = $httpd::params::priority,
    $servername         = $httpd::params::servername,
    $serveraliases      = $httpd::params::serveraliases,
    $auth               = $httpd::params::auth,
    $redirect_ssl       = $httpd::params::redirect_ssl,
    $options            = $httpd::params::options,
    $apache_name        = $httpd::params::apache_name,
    $vhost_name         = $httpd::params::vhost_name,
    $content            = undef,
  ) {

  include ::httpd

  if $servername == undef {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  if $ssl == true {
    include ::httpd::ssl
  }

  # Since the template will use auth, redirect to https requires mod_rewrite
  if $redirect_ssl == true {
    case $::operatingsystem {
      'debian','ubuntu': {
        Httpd_mod <| title == 'rewrite' |>
      }
      default: { }
    }
  }

  # Proccess content or template
  if $content == undef {
    content_real = $content
  } else {
    content_real = template($template)
  }

  file { "${priority}-${name}.conf":
      path    => "${httpd::params::vdir}/${priority}-${name}.conf",
      content => $content_real,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package['httpd'],
      notify  => Service['httpd'],
  }

  if $configure_firewall {
    if ! defined(Firewall["0100-INPUT ACCEPT ${port}"]) {
      @firewall {
        "0100-INPUT ACCEPT ${port}":
          action => 'accept',
          dport  => '$port',
          proto  => 'tcp'
      }
    }
  }
}

