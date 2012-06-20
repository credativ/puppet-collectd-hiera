class collectd {
  define plugin ($options="") {
    file {
      "/etc/collectd/collectd.d/${name}.conf":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 0644,
        content => template("collectd/plugin.conf.erb"),
        notify  => Service['ssh']
    }
  }
  package {
    collectd: ensure => installed;
  }

  file {
    "/etc/collectd/collectd.conf":
      content => template("collectd/etc/collectd/collectd.conf.erb"),
      notify  => Exec["collectd restart"];

    "/etc/collectd/collectd.d/":
      ensure  => directory,
      purge   => true,
      notify  => Service['ssh']
  }

  service { 'collectd':
  	ensure      => $ensure_running,
	enable      => $ensure_enabled,
	hasrestart  => true,
	hasstatus   => true,
	require     => Package['collectd']
  }

  $server = params_lookup('osf_mng_server_ip')

  #load standardplugins
  plugin { 'contextswitch': }
  plugin { 'cpu': }
  plugin { 'df': }
  plugin { 'disk': }
  plugin { 'entropy': }
  plugin { 'interface': }
  plugin { 'irq': }
  plugin { 'load': }
  plugin { 'memory': }
  plugin { 'processes': }
  plugin { 'swap': }
  plugin { 'users': }
  plugin { 'network':
    options => 'Server ${server}'
  }


}
