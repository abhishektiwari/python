# == Class: python::virtualenv
#
# Goes into manifests/virtualenv.pp

class python::virtualenv {
	# resources
	package { "python-virtualenv":
		ensure     => installed,
		require    => Package['python-setuptools', 'python-dev', 'build-essential'],
	}
	
}