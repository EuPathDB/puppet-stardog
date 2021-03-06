# Stardog default parameters
class stardog::params {

  $version = '4.1'
  $install_dir = '/opt'
  $home = '/var/lib/stardog'
  $port = 5820
  $user = 'stardog'
  $manage_user = true
  $ssl = 'disable'
  $keystore = '/var/lib/stardog/keystore.jks'
  $ks_passwd = 'password'

  $sysconfig = '/etc/sysconfig/stardog'

  $service_ensure = 'running'
  $service_enable = true

  $java_args = undef
  $java_home = undef

  $sdpass = []
  $properties = {}
}