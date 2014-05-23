# == Class: python::virtualenv
#
# Goes into manifests/virtualenv.pp

class python::virtualenv {
	# Install virtualenv
	package { "python-virtualenv":
		ensure     => installed,
		require    => Class[python],
	}
	# Install virtualenvwrapper
	package { "python-virtualenvwrapper":
		ensure => installed,
		require    => Package['python-virtualenv'],
	}
	
}