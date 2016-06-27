# Setup ssl java keystore.
# Example hiera
#         stardog::ssl::certificate:
#           src: 'puppet:///modules/profiles/ssl/demo-rsa.crt'
#           dest: '/etc/pki/tls/certs/demo-rsa.crt'
#         stardog::ssl::private_key:
#           src: 'puppet:///modules/profiles/ssl/demo-rsa.key'
#           dest: '/etc/pki/tls/private/demo-rsa.key'
#         stardog::ssl::ca:
#           src:
#           dest: '/etc/pki/tls/certs/apidb-ca-rsa.crt'
#
# Where `src` is the source of the file to be installed on the server at
# the location set for `dest`. If `src` key value is not set then the
# file is assumed to be managed in another module.
#
class stardog::ssl_keystore (
  Hash   $certificate = {},
  Hash   $private_key = {},
  Hash   $ca          = {},
  String $password    = 'password',
) {

  File {
    require => File[$stardog::home],
  }

  if $ca['src'] {
    file { $ca['dest']:
      ensure => 'file',
      source => $ca['src'],
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
  }

  if $certificate['src'] {
    file { $certificate['dest']:
      ensure => 'file',
      source => $certificate['src'],
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
  }

  if $private_key['src'] {
    file {  $private_key['dest']:
      ensure => 'file',
      source => $private_key['src'],
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
  }

  java_ks { 'stardog-server:/var/lib/stardog/keystore.jks':
    ensure       => latest,
    certificate  =>  $certificate['dest'],
    private_key  =>  $private_key['dest'],
    password     => 'password',
    trustcacerts => true,
  }

  java_ks { 'ca:/var/lib/stardog/keystore.jks':
    ensure       => latest,
    certificate  => $ca['dest'],
    password     => $password,
    trustcacerts => true,
  }

}