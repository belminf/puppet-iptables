if $fail2ban_installed {
	$pre_iptables_save = 'service fail2ban stop &&'
	$post_iptables_save = '&& service fail2ban start'
}

$iptables_save = "${pre_iptables_save}iptables -P INPUT DROP && iptables -P OUTPUT ACCEPT && service iptables save${post_iptables_save}"


exec { 'iptables-persist':
	path => '/sbin/',
	command => $iptables_save,
	refreshonly => true,
}

Firewall {
	notify => Exec['iptables-persist'],
}


stage { pre: before => Stage[main] }
class { 'iptables': stage => 'pre' }

class iptables {
	
	if $fail2ban_installed == 'false' {
		resources { 'firewall':
			purge => true,
		}
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
