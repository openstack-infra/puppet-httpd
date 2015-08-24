include ::httpd

::httpd::vhost { 'localhost':
  port     => 80,
  docroot  => '/var/www',
  priority => '50',
  ssl      => false,
}

::httpd::vhost::proxy { 'proxy':
  port     => 443,
  dest     => 'http://www.openstack.org',
  priority => '50',
  ssl      => false,
}

httpd_mod { 'proxy':
  ensure => present,
}

httpd_mod { 'proxy_http':
  ensure => present,
}
