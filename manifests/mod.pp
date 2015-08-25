# defined type to wrap httpd_mod
# httpd_mod doesn't autobefore the httpd service, this does
define httpd::mod (
) {
  httpd_mod { $name:
    ensure => present,
    before => Service['httpd'],
  }

}
