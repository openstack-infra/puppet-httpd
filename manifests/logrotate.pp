# == Class: httpd::logrotate
#
class httpd::logrotate (
  $options = [
      'daily',
      'missingok',
      'rotate 30',
      'compress',
      'delaycompress',
      'notifempty',
      'create 640 root adm',
      'sharedscripts'
  ]
) inherits httpd::params {
  include ::logrotate

  $apache_logdir = "/var/log/${::httpd::params::apache_name}"
  $logrotate_name = $::httpd::params::apache_name

  ::logrotate::file { $logrotate_name:
    log     => "${apache_logdir}/*.log",
    options => $options,
  }
}
