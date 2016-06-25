# manage Stardog service
class stardog::service (
  $ensure = $stardog::params::service_ensure,
  $enable = $stardog::params::service_enable,
) {
  service { 'stardog':
    ensure => $ensure,
    enable => $enable,
  }
}
