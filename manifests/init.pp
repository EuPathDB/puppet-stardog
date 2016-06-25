#
class stardog (
  $package_url = undef,
  $license_url = undef,
  $version     = $stardog::params::version,
  $home        = $stardog::params::home,
  $base        = $stardog::params::base,
  $port        = $stardog::params::port,
  $user        = $stardog::params::user,
  $manage_user = $stardog::params::manage_user,
) inherits stardog::params {

  if $manage_user {
    user { $user:
      ensure     => 'present',
      home       => $home,
      managehome => false,
      shell      => '/sbin/nologin',
    }
  }

  archive { "/tmp/stardog-${version}.zip":
    ensure       => present,
    extract      => true,
    extract_path => "${stardog::params::inst_dir}",
    source       => $package_url,
    creates      => $base,
    cleanup      => true,
  }

  archive { "${home}/stardog-license-key.bin":
    ensure  => present,
    extract => false,
    source  => $license_url,
    creates => "${home}/stardog-license-key.bin",
    cleanup => false,
  }

  file { '/usr/lib/systemd/system/stardog.service':
    ensure  => 'file',
    content => template("stardog/stardog.service.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0755'
  }

  file { '/etc/sysconfig/stardog':
    ensure  => 'file',
    content => template("stardog/sysconfig_env.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0755'
  }


#  exec { 
#    environment => [ 'STARDOG_HOME=/data/stardog' ]
#  }

#   service { 'stardog':
#     provider => base,
#     ensure   => 'running',
#     start    => '/etc/init.d/postgresql start',
#     restart  => '/etc/init.d/postgresql restart',
#     stop     => '/etc/init.d/postgresql stop',
#     status   => "pg_lsclusters -h | awk 'BEGIN {rc=0} {if (\$4 != \"online\") rc=3} END { exit rc }'",
#   }
}
