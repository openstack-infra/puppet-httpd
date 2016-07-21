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
    $docroot,
    $port,
    $apache_name        = $httpd::params::apache_name,
    $auth               = $httpd::params::auth,
    $configure_firewall = true,
    $options            = $httpd::params::options,
    $priority           = $httpd::params::priority,
    $redirect_ssl       = $httpd::params::redirect_ssl,
    $serveraliases      = $httpd::params::serveraliases,
    $servername         = $httpd::params::servername,
    $ssl                = $httpd::params::ssl,
    $template           = $httpd::params::template,
    $vhost_name         = $httpd::params::vhost_name,
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

  # The Apache mod_version module only needs to be enabled on Ubuntu 12.04
  # as it comes compiled and enabled by default on newer OS, including CentOS
  if !defined(Httpd::Mod['version']) and $::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '12.04' {
    httpd::mod { 'version': ensure => present }
  }

  # selinux may deny directory listing and access to subdirectories
  # so update context to allow it
  if $::osfamily == 'RedHat' {
    if ! defined(Exec["update_context_${docroot}"]) {
      exec { "update_context_${docroot}":
        command => "chcon -R -t httpd_sys_content_t ${docroot}/",
        unless  => "ls -lZ ${docroot} | grep httpd_sys_content_t",
        onlyif  =>  "test -d ${docroot}",
        path    => '/bin:/usr/bin:/usr/local/bin:/usr/sbin',
        require => Package['httpd'],
        notify  => Service['httpd'],
      }
    }
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

