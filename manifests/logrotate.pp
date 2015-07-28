# == Class: httpd::logrotate
#
class httpd::logrotate(
  $options = [
      'daily',
      'missingok',
      'rotate 30',
      'compress',
      'delaycompress',
      'notifempty',
      'create 640 root adm',
      'sharedscripts',
  ]
) {
  include ::logrotate

  if $::osfamily  == 'RedHat' {
    $apache_logdir = '/var/log/httpd'
    $logrotate_name = 'httpd'
  }
  else {
    $apache_logdir = '/var/log/apache2'
    $logrotate_name = 'apache2'
  }
  ::logrotate::file { $logrotate_name:
    log     => "${apache_logdir}/*.log",
    options => $options,
  }
}
