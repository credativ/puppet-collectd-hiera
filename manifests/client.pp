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
# [*server*]
#   Define the hostname/ip of the collectd server
#   Default: undef
# == Author:
#
#   Patrick Schoenfeld <patrick.schoenfeld@credativ.de>
class collectd::client (
    $ensure             = params_lookup('ensure'),
    $manage_config      = params_lookup('manage_config'),
    $ensure_running     = params_lookup('ensure_running'),
    $ensure_enabled     = params_lookup('ensure_enabled'),
    $config_source      = params_lookup('config_source'),
    $config_template    = params_lookup('config_template'),
    $disabled_hosts     = params_lookup('disabled_hosts'),
    $server             = params_lookup('server'),
    ) inherits collectd::params {

    plugin { 'network':
        options => "\tServer \"${server}\""
    }

    Service <| title == 'collectd' |> {
        ensure          => $ensure_running,
        enable          => $ensure_enabled,
    }
    
    if $::hostname in $disabled_hosts {
        Service <| title == 'collectd' |> {
            enable => false,
            ensure => 'stopped'
        } 
    }
}
