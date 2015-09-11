class { '::httpd': }
class { '::httpd::dev': }
class { '::httpd::php': }
class { '::httpd::python': }
class { '::httpd::ssl': }
httpd::vhost { 'localhost':
  port     => 80,
  docroot  => '/var/www',
  priority => 50,
}
