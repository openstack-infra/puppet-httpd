# == Class: httpd::logrotate
#
class httpd::logrotate (
  $firstaction = 'undef',
  $lastaction  = 'undef',
  $options     = [
      'daily',
      'missingok',
      'rotate 30',
      'compress',
      'delaycompress',
      'notifempty',
      'create 640 root adm',
  ],
  $prerotate   = [
    "if [ -d /etc/logrotate.d/${::httpd::params::apache_name}-prerotate ]; then \\",
    "  run-parts /etc/logrotate.d/${::httpd::params::apache_name}-prerotate; fi ; \\",
  ],
  $postrotate  = [
    "if service ${::httpd::params::apache_name} status > /dev/null; then \\",
    "  service ${::httpd::params::apache_name} reload > /dev/null; fi; \\",
  ],
) inherits httpd::params {
  include ::logrotate

  $apache_logdir = "/var/log/${::httpd::params::apache_name}"
  $logrotate_name = $::httpd::params::apache_name

  ::logrotate::file { $logrotate_name:
    log         => "${apache_logdir}/*.log",
    options     => $options,
    prerotate   => $prerotate,
    postrotate  => $postrotate,
    firstaction => $firstaction,
    lastaction  => $lastaction,
  }
}
