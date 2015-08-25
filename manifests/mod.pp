# defined type to wrap httpd_mod
# httpd_mod doesn't ensure that the service is up first, this does
define httpd::mod (
  $ensure = present,
) {

  if $::osfamily == 'Debian' {
    httpd_mod { $name:
      ensure => $ensure,
      notify => Service['httpd'],
    }
  }
  if $::osfamily == 'RedHat' {
    debug('Enabling modules is a noop on redhat, doing nothing')
  }

}
