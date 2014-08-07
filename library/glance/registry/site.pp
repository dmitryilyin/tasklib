class { 'glance::registry':
  verbose           => $verbose,
  debug             => $debug,
  bind_host         => $bind_host,
  auth_host         => $keystone_host,
  auth_port         => '35357',
  auth_type         => 'keystone',
  keystone_tenant   => 'services',
  keystone_user     => 'glance',
  keystone_password => $glance_user_password,
  sql_connection    => $sql_connection,
  enabled           => $enabled,
  use_syslog        => $use_syslog,
  syslog_log_facility => $syslog_log_facility,
  syslog_log_level    => $syslog_log_level,
}
