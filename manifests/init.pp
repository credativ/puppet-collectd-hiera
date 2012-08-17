# = Class: collectd
#
# Module to manage collectd
#
# == Requirements:
#
# - This module makes use of the example42 functions in the puppi module
#   (https://github.com/credativ/puppet-example42lib)
#
# == Parameters:
#
# [*ensure*]
#   What state to ensure for the package. Accepts the same values
#   as the parameter of the same name for a package type.
#   Default: present
#   
# [*ensure_running*]
#   Weither to ensure running collectd or not.
#   Default: running
#
# [*ensure_enabled*]
#   Weither to ensure that collectd is started on boot or not.
#   Default: true
#
# [*disabled_hosts*]
#   A list of hosts whose collectd will be disabled, if their
#   hostname matches a name in the list.
#
# == Author:
#
#   Patrick Schoenfeld <patrick.schoenfeld@credativ.de>
class collectd (
    $ensure             = params_lookup('ensure'),
    $manage_config      = params_lookup('manage_config'),
    $ensure_running     = params_lookup('ensure_running'),
    $ensure_enabled     = params_lookup('ensure_enabled'),
    $config_source      = params_lookup('config_source'),
    $config_template    = params_lookup('config_template'),
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
