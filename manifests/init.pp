#
class stardog (
  Hash               $package_source = undef,
  Hash               $license_source = undef,
  String             $version        = $stardog::params::version,
  String             $home           = $stardog::params::home,
  String             $install_dir    = $stardog::params::install_dir,
  Enum[
    'disable',
    'enable',
    'require']       $ssl            = $stardog::params::use_ssl,
  String             $keystore       = $stardog::params::keystore,
  Integer            $port           = $stardog::params::port,
  String             $user           = $stardog::params::user,
  Boolean            $manage_user    = $stardog::params::manage_user,
  String             $java_args      = $stardog::params::java_args,
  String             $sysconfig      = $stardog::params::sysconfig,
  Hash               $properties     = $stardog::params::properties,
  Array              $sdpass         = $stardog::params::sdpass,
  String             $java_home      = $stardog::params::java_home,
) inherits stardog::params {

  include ::stardog::service

  if $ssl != 'disable' {
    include ::stardog::ssl
  }

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
    ensure        => present,
    extract       => true,
    extract_path  => $stardog::params::install_dir,
    source        => $package_source['url'],
    checksum      => $package_source['sha1'],
    checksum_type => 'sha1',
    creates       => $base,
    cleanup       => true,
    notify        => Service['stardog'],
  }

  file { $home:
    ensure  => 'directory',
    owner   => $user,
    recurse => true,
  }

  archive { "${home}/stardog-license-key.bin":
    ensure        => present,
    extract       => false,
    source        => $license_source['url'],
    checksum      => $license_source['sha1'],
    checksum_type => 'sha1',
    creates       => "${home}/stardog-license-key.bin",
    cleanup       => false,
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

  exec { 'reload_systectl':
    command     => 'systemctl daemon-reload',
    path        => ['/usr/bin', '/bin'],
    refreshonly => true,
    subscribe   => File['/usr/lib/systemd/system/stardog.service'],
  }

}
