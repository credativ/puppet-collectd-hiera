class collectd::client inherits collectd {
	$server = params_lookup('osf_mng_server_ip', 'global')

	plugin { 'network':
		options => "\tServer \"${server}\""
	}
}
