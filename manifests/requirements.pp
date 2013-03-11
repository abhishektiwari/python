# == Class: python::requirements
#
# Goes into manifests/requirements.pp
#
# === Parameters
#
# === Examples
#

class python::requirements ($req_file, $venv, $owner=undef, $group=undef) {
    # resources
    $checksum     = "$venv/requirements.checksum"
    $requirements = "/tmp/requirements.txt"

    Exec {
        user  => $owner,
        group => $group,
        cwd   => "/tmp",
    }

    file {"${req_file}":
        ensure  => present,
    }

    exec {$requirements:
        command     => "cp ${req_file} ${requirements}",
    }
    # We create a sha1 checksum of the requirements file so that
    # we can detect when it changes:
    exec { "create new checksum of name requirements":
        command => "sha1sum $requirements > $checksum",
        unless  => "sha1sum -c $checksum",
        require => Exec[$requirements],
    }

    exec { "update name requirements":
        command     => "$venv/bin/pip install -Ur $requirements",
        cwd         => $venv,
        subscribe   => Exec["create new checksum of name requirements"],
        refreshonly => true,
        timeout     => 1800, # sometimes, this can take a while
    }
}
