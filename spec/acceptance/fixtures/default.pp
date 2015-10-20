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

# Enable a secondary port to test proxy and redirect modules
$override = '
Listen 8080
'
file { "${::httpd::params::vdir}override.conf":
  content => $override,
}
file { '/html':
  ensure => directory,
  mode   => '0755',
}
file { '/html/acceptance.txt':
  ensure  => present,
  mode    => '0644',
  content => 'Acceptance Test',
  require => File['/html'],
}
httpd::vhost { 'acceptance-server':
  servername => 'localhost',
  port       => 8080,
  docroot    => '/html',
  priority   => 50,
}

httpd::mod { 'proxy': ensure => present; }
httpd::mod { 'proxy_http': ensure => present; }
httpd::vhost::proxy { 'proxy':
  port => 80,
  dest => 'http://localhost:8080',
}

httpd::vhost::redirect { 'redirect':
  port => 80,
  dest => 'http://localhost:8080/acceptance.txt',
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

