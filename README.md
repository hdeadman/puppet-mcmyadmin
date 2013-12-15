#puppet-mcmyadmin

![Minecraft](http://i.imgur.com/AOJ7jxN.png)

###Overview

This module will install [McMyAdmin](http://www.mcmyadmin.com/), a [Minecraft](http://minecraft.net/) control panel.

###Details

32-bit versions of McMyAdmin use Mono. If you install McMyAdmin 32-bit, your distro package will be installed.  The 64-bit version of McMyAdmin includes configuration files, which will be placed in `/usr/local/etc/`

Minecraft itself requires Java, which can optionally be installed with this module by using the `manage_java` parameter.

This module includes an init script, which will launch McMyAdmin from within a screen session.  This module can optionally install screen by using the `manage_screen` parameter.

If all goes well, you should be able to login to the McMyAdmin web interface after using this module.

**Note:** this doesn't configure McMyAdmin or initiate the Minecraft server installation - that is handled via the McMyAdmin web interface.  The only thing configured is the listening address and port.

###Usage
####Basic, default use:

```puppet
include mcmyadmin
```

Example of running with the webserver on a custom port:

```puppet
class { 'mcmyadmin':
  webserver_port  => '9090',
}
```

###Parameters
####`install_arch`

This determines which version of the McMyAdmin installer will be downloaded and installed.  Default: '64' on x86_64/Linux systems; '32' on all others.

####`password`

The password to use for the McMyAdmin web admin user.  Default: `mcmyadmin`

####`user`

The user to operate as.  A home directory will be created.  Default: `minecraft`

####`group`

Group to create.  The `user` will be a member of this.  Default: `minecraft`

####`homedir`

Path to the home directory.  Default: `/home/minecraft`

####`install_dir`

Where McMyAdmin will be installed.  Default: `${homedir}/McMyAdmin`

####`webserver_port`

Port for the McMyAdmin web service to listen on. Default: `8080`

####`webserver_addr`

Address for the McMyAdmin web service to listen on. Default: `+`

####`manage_java`

Boolean: true/false

Whether to install Java or not.  Required for Minecraft.

####`manage_screen`

Boolean: true/false

Whether to install screen or not.  The init script executes McMyAdmin within a screen session.

####`manage_mono`

Boolean: true/false

Whether to install mono distro package.  This is only relevant when `install_arch` isn't '64', which only applies to Linux.  Note: EPEL is required on RedHat-like systems.

####`mono_pkg`

Mono package to be installed.  Default: mono-complete on Debian/Ubuntu. mono-core on RedHat/CentOS (EPEL is required). lang/mono on FreeBSD.

####`screen_pkg`

Screen package to be installed.
Default: RedHat/Debian: screen;  FreeBSD: sysutils/screen

####`manage_curl`

Boolean: true/false

Whether to manage the `curl` package or not.  Defaults to `false` on Linux and `true` on FreeBSD.  You probably don't need to change this.  If you're running FreeBSD and are already managing the `curl` package with Puppet, set this parameter to `false`

The `staging` module that this module uses requires `curl` or `wget` to download the remote package, neither of which are installed by default on FreeBSD.

####`curl_pkg`

curl package to be installed.  `curl` on Linux and `ftp/curl` on FreeBSD.
This parameter doesn't matter if `manage_curl` isn't set to `true`

####`staging_dir`

Full path to the staging directory (see above). This should be persistent across reboots.

This is `/opt/staging` on Linux (as set by the `staging` module) and `/var/tmp/staging` on FreeBSD (as set by the `mcmyadmin` module)

You probably don't need to change this parameter.

###Limitations

This has been tested on CentOS, Ubuntu, and FreeBSD 9.2 with pkgng.

###TODO

* Better rspec testing
* Cleanup `mcmyadmin::install`

###FreeBSD Notes

This was tested with `pkgng`

You can use a `pkgng` provider by performing:

```shell
puppet module install zleslie-pkgng
```

and doing something like this on your system:

```puppet
Package {
  provider => 'pkgng',
}
```

This will set `pkgng` to be the default provider for package installation.

The `staging` module that is used by this module needs `wget` or `curl` installed.
It also uses a directory called `/opt` for staging, which doesn't exist by
default on FreeBSD systems.

###Contributing

Contributions very welcome, as well as general comments.

This module is developed independently and not on the behalf of my employer.

Josh Beard (<beard@puppetlabs.com>)

###Copyrights

[McMyAdmin](http://www.mcmyadmin.com/) is Copyright 2013 CubeCoders Limited.

[Minecraft](http://www.minecraft.net/) is Copyright 2009-2013 Mojang.  "Minecraft" is a trademark of Notch Development AB.
