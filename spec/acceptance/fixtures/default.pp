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

httpd::mod { 'rewrite':
  ensure => present,
}

case $::operatingsystem {
  'ubuntu', 'debian': {
    class { '::httpd::python': }
  }
  default: {}
}

