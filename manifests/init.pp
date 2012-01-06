class { 'iptables': stage => 'pre' }

class iptables {

	resources { 'firewall':
	       purge => true,
	}

	firewall { '000 in: accept local':
		chain => 'INPUT',
		iniface => 'lo',
		action => 'accept',
	}

	firewall { '000 in: accept related and established':
		chain => 'INPUT',
		state => ['ESTABLISHED', 'RELATED'],
		action => 'accept',
	}
	
}
