$iptables_save = "${pre_iptables_save}iptables -P INPUT DROP && iptables -P OUTPUT ACCEPT && service iptables save${post_iptables_save}"

if $fail2ban_installed == 'true' {
	$pre_iptables_save = 'service fail2ban stop &&'
	$post_iptables_save = '&& service fail2ban start'
}

exec { 'iptables-persist':
	path => '/sbin/',
	command => $iptables_save,
	refreshonly => true,
}

Firewall {
	notify => Exec['iptables-persist'],
}
