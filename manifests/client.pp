class collectd::client (
        $ensure         = params_lookup('ensure'),
        $ensure_running = params_lookup('ensure_running'),
        $ensure_enabled = params_lookup('ensure_enabled'),
        $server         = params_lookup('server'),
    ) inherits collectd {

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
