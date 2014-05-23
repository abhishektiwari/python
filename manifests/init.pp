# == Class: python
#
# Goes into manifest/init.pp


class python {
	# resources
	package { "python-setuptools":
		ensure   => installed,
	}
	package { "python-dev":
		ensure   => installed,
	}
	package { "git":
		ensure => installed,
	}
}