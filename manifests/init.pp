#
class stardog (
  $package_source = undef,
  $license_source = undef,
  $version        = $stardog::params::version,
  $home           = $stardog::params::home,
  $install_dir    = $stardog::params::install_dir,
  $port           = $stardog::params::port,
  $user           = $stardog::params::user,
  $manage_user    = $stardog::params::manage_user,
  $java_args      = $stardog::params::java_args,
  $sysconfig      = $stardog::params::sysconfig,
  $properties     = $stardog::params::properties,
  $sdpass         = $stardog::params::sdpass,
  $java_home      = $stardog::params::java_home,
) inherits stardog::params {

  include ::stardog::service

  $base = "${install_dir}/stardog-${version}"

  if $manage_user {
    user { $user:
      ensure     => 'present',
      home       => $home,
      managehome => false,
      shell      => '/bin/bash',
    }
  }

  archive { "/tmp/stardog-${version}.zip":
    ensure       => present,
    extract      => true,
    extract_path => $stardog::params::install_dir,
    source       => $package_source['url'],
    checksum     => $package_source['sha1'],
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
    ensure   => present,
    extract  => false,
    source   => $license_source['url'],
    checksum => $license_source['sha1'],
    creates  => "${home}/stardog-license-key.bin",
    cleanup  => false,
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

  file { "${home}/.sdpass":
    ensure  => 'file',
    content => template('stardog/sdpass.erb'),
    owner   => $user,
    mode    => '0640',
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
