# stardog

A Puppet module to install [Stardog](http://stardog.com) on CentOS.


## Usage:

    include stardog

## Requirements:

Java must be installed on the system. This module does not manage java.

Possibly you will need to open firewall ports. This module does not manage that.


stardog::package_url

URL to download stardog zip package. Stardog requires registration
before accessing a temporary download URL. You will need to host the zip
package at a stable, internal location for this module to fetch.

stardog::license_url

URL to download stardog license file. Stardog requires registration
before providing a license file. You will need to host the license
file at a stable, internal location for this module to fetch.


stardog::user

The user that the stardog daemon will run as. This user will be created
unless you set `stardog::manage_user` to false.

stardog::manage_user

Boolean choice whether to manage the user that the stardog daemon will
run as (`stardog::user`). The default is true. The user