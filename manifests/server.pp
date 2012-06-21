class collectd::server inherits collectd {
	$listenip = params_lookup('osf_mng_server_ip', 'global')

	plugin { 'network':
		options => "\tListen \"${listenip}\" \"25826\""
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
