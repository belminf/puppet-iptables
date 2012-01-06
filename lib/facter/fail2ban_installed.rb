Facter.add("fail2ban_installed") do
	setcode do
		if FileTest.exists?("/usr/bin/fail2ban-server")
			"true"
		else
			"false"
		end
	end
end
