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
<Directory "/tmp">
	Options All
	AllowOverride All
	Require all granted
</Directory>
'
file { "${::httpd::params::vdir}override.conf":
  content => $override,
}
file { '/tmp/acceptance.txt':
  ensure  => present,
  owner   => $::httpd::params::user,
  group   => $::httpd::params::group,
  content => 'Acceptance Test',
}
httpd::vhost { 'acceptance-server':
  servername => 'localhost',
  port       => 8080,
  docroot    => '/tmp',
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

