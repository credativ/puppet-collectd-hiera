class collectd (
    $disabled_hosts = params_lookup('disabled_hosts')
  ) inherits collectd::params {

  define plugin ($options="") {
    file {
      "/etc/collectd/collectd.d/${name}.conf":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 0644,
        content => template("collectd/plugin.conf.erb"),
        notify  => Service['collectd']
    }
  }
  package { 'libgcrypt11':
      ensure  => $ensure,
  }

  package { 'collectd': 
        ensure => installed,
        require => Package['libgcrypt11']
  }

  file {
    "/etc/collectd/collectd.conf":
      content => template("collectd/etc/collectd/collectd.conf.erb"),
      notify  => Service['collectd'];

    "/etc/collectd/collectd.d/":
      ensure  => directory,
      purge   => true,
      notify  => Service['collectd'];
  }

  service { 'collectd':
    ensure      => $ensure_running,
    enable      => $ensure_enabled,
    hasrestart  => true,
    hasstatus   => true,
    require     => Package['collectd']
  }

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

}
