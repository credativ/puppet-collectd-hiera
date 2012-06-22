class collectd::server (
        $ensure         = params_lookup('ensure'),
        $ensure_running = params_lookup('ensure_running'),
        $ensure_enabled = params_lookup('ensure_enabled'),
        $listener       = params_lookup('listener'),
    ) inherits collectd {

    Service <| title == 'collectd' |> {
        ensure          => $ensure_running,
        enable          => $ensure_enabled,
    }
    
    if $::hostname in $disabled_hosts {
        Service <| title == 'collected' |> {
            enable => false,
            ensure => 'stopped'
        } 
    }

         
    plugin { 'network':
        options => "\tListen \"${listener}\" \"25826\""
    }

    plugin { 'rrdtool':
        options => "\tDataDir \"/var/lib/collectd/rrd\"
\tCacheTimeout 120
\tCacheFlush 900
\tWritesPerSecond 30
\tRandomTimeout 0"
}

    package { 'collectd-web':
        ensure => installed,
        require => Package['collectd']
    }

}
