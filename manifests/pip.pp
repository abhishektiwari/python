# == Class: python::pip
#
# Goes into manifests/pip.pp

class python::pip {
	# resources
	package { "python-pip":
		ensure     => installed,
		require    => Class[python],
	}
	
}