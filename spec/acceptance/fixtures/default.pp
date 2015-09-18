class { '::httpd': }
class { '::httpd::dev': }
class { '::httpd::php': }
class { '::httpd::mod::wsgi': }
class { '::httpd::ssl': }
httpd::vhost { 'localhost':
  port         => 80,
  docroot      => '/var/www',
  priority     => 50,
  redirect_ssl => true,
}

httpd::mod { 'proxy': ensure => present; }
httpd::mod { 'proxy_http': ensure => present; }
httpd::vhost::proxy { 'openstack-proxy':
  port => 80,
  dest => 'http://review.openstack.org',
}

httpd::vhost::redirect { 'openstack-redirect':
  port => 80,
  dest => 'http://www.openstack.org',
}

httpd::mod { 'rewrite':
  ensure => present,
}

case $::operatingsystem {
  'ubuntu', 'debian': {
    class { '::httpd::python': }
  }
  default: {}
}

