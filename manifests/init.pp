#
class stardog (
  $package_url = undef,
  $license_url = undef,
  $version     = $stardog::params::version,
  $home        = $stardog::params::home,
  $install_dir = $stardog::params::install_dir,
  $port        = $stardog::params::port,
  $user        = $stardog::params::user,
  $manage_user = $stardog::params::manage_user,
  $java_args   = $stardog::params::java_args,
  $sysconfig   = $stardog::params::sysconfig,
  $properties  = $stardog::params::properties,
) inherits stardog::params {

  include ::stardog::service

  $base = "${install_dir}/stardog-${version}"

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
    extract_path => $stardog::params::install_dir,
    source       => $package_url,
    creates      => $base,
    cleanup      => true,
    notify       => Service['stardog'],
  }

  file { $home:
    ensure  => 'directory',
    owner   => $user,
    recurse => true,
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
    content => template('stardog/stardog.service.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['stardog'],
  }

  file { "${home}/stardog.properties":
    ensure  => 'file',
    content => template('stardog/stardog.properties.erb'),
    owner   => $user,
    mode    => '0640',
    notify  => Service['stardog'],
  }

  file { $sysconfig:
    ensure  => 'file',
    content => template('stardog/sysconfig_env.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['stardog'],
  }

  file { '/etc/profile.d/stardog.sh':
    ensure  => 'file',
    content => template('stardog/profile.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
