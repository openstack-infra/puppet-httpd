# defined type to wrap httpd_mod
# httpd_mod doesn't autobefore the httpd service, this does
define httpd::mod (
  $ensure = undef,
) {

  if ($::osfamily == 'Debian') {
    httpd_mod { $name:
      ensure => $ensure,
      before => Service['httpd'],
      notify => Service['httpd'],
    }
  }

}
