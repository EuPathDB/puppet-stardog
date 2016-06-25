# stardog

A Puppet module to install [Stardog](http://stardog.com) on CentOS.


## Usage:

    include stardog

## Requirements:

Java must be installed on the system. This module does not manage java.

Possibly you will need to open firewall ports. This module does not manage that.

## Parameters

#### `stardog::package_url`

URL to download stardog zip package. Stardog requires registration
before accessing a temporary download URL. You will need to host the zip
package at a stable, internal location for this module to fetch.

#### `stardog::license_url`

URL to download stardog license file. Stardog requires registration
before providing a license file. You will need to host the license
file at a stable, internal location for this module to fetch.


#### `stardog::user`

The user that the stardog daemon will run as. This user will be created
unless you set `stardog::manage_user` to false.

#### `stardog::manage_user`

Boolean choice whether to manage the user that the stardog daemon will
run as (`stardog::user`). The default is true.

#### `stardog::version`

The version of Stardog to install. The value must match the value in the
zip package name, i.e. `stardog-${stardog::version}.zip`. The default is
undefined, therefore you must define this parameter.

#### `stardog::home`

The full path to the Stardog working directory of databases and related
files. The default is `/var/lib/stardog`.

#### `stardog::base`

The full path to the Stardog installation directory. The default is
`/opt/stardog-${stardog::version}`.

#### `stardog::port`

