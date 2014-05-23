# == Class: python::myvirtualenv
#
# Goes into manifests/myvirtualenv.pp

class python::myvirtualenv ($app_name= "myvirtualenv", $owner="vagrant", group="vagrant", $req_file=undef, $shared_folder="/vagrant") {
	# resources
	$venv_root   = "/home/${owner}/.virtualenvs/${app_name}"
	$root_parent = "/home/${owner}/.virtualenvs"

	file { "${root_parent}":
		ensure => directory,
		owner => $owner,
		group => $group,
	}

	exec { "virtualenv ${venv_root}":
		command => "virtualenv ${venv_root}",
		user    => $owner,
		creates => $venv_root,
		require => [File[$root_parent], Package["python-virtualenv"]],
		notify  => Exec["update distribute and pip in ${venv_root}"],
	}

	exec { "update distribute and pip in ${venv_root}":
		command => "$venv_root/bin/pip install -U distribute pip",
		refreshonly => true,
    }

	if $owner == 'root' {
		$uhome = "/${owner}"
	}
	else {
		$uhome = "/home/${owner}"
	}
	file {"${uhome}/.bash_profile":
		ensure  => present,
		owner   => $owner,
		group   => $group,
		mode    => '0644',
		# content or source or target
		content => template('python/bash_profile.erb'),
		require => Exec["virtualenv $venv_root"],
	}

    if $req_file {
		class {'python::requirements':
			req_file=> $req_file,
			venv    => $venv_root,
			owner   => $owner,
			group   => $group,
			require => Exec["virtualenv $venv_root"],
    	}
    }
	
}