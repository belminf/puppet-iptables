# Make sure we run this before anything
stage { pre: before => Stage[main] }
class { 'iptables': stage => 'pre' }

class iptables {

	resources { 'firewall':
	       purge => true,
	}

	firewall { '000 input: accept local':
		chain => 'INPUT',
		iniface => 'lo',
		action => 'accept',
	}

	firewall { '000 input: accept related and established':
		chain => 'INPUT',
		state => ['ESTABLISHED', 'RELATED'],
		action => 'accept',
	}

	firewall { '000 input: accept dns':
		chain => 'INPUT',
		proto => 'udp',
		sport => 53,
		action => 'accept',
	}
}

define iptables::hole ($proto='tcp', $port, $source=undef) {
	firewall { "100 input: $name":
		chain => 'INPUT',
		proto => $proto,
		dport => $port,
		source => $source,
		action => 'accept',
        }
}
