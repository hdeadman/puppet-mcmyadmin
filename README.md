# puppet-mcmyadmin

![Minecraft](http://i.imgur.com/AOJ7jxN.png)

[![Build Status](https://travis-ci.org/joshbeard/puppet-mcmyadmin.svg?branch=master)](https://travis-ci.org/joshbeard/puppet-mcmyadmin)

#### Table of Contents

1. [Overview and details](#overview)
2. [Usage Examples](#usage-examples)
    * [Multiple Instances](#multiple-instances)
    * [Single Instance](#single-instance)
3. [mcmyadmin Class Parameters](#mcmyadmin-class-parameters)
4. [Defined Type: mcmyadmin::instance](#defined-type-mcmyadmininstance)
5. [Backwards Compatibility](#backwards-compatibility)
5. [Limitations](#limitations)
6. [FreeBSD Notes](#freebsd-notes)
7. [Contributing](#contributing)
8. [Copyrights](#copyrights)

## Overview

This module will install [McMyAdmin](http://www.mcmyadmin.com/), a [Minecraft](http://minecraft.net/) control panel.  Multiple instances can be installed.

### Details

32-bit versions of McMyAdmin use Mono. If you install McMyAdmin 32-bit, your distro package will be installed.  The 64-bit version of McMyAdmin includes configuration files, which will be placed in `/usr/local/etc/`

Minecraft itself requires Java, which can optionally be installed with this module by using the `manage_java` parameter.

This module installs an init script for each instance, which will launch McMyAdmin from within a screen session.  This module can optionally install screen by using the `manage_screen` parameter.

If all goes well, you should be able to login to the McMyAdmin web interface after using this module.

**Note:** this doesn't configure McMyAdmin or initiate the Minecraft server installation - that is handled via the McMyAdmin web interface.  The only thing configured is the listening address and port.

**NEW:** This module now supports multiple instances of McMyAdmin on the same server.  You must explicitly provide a port number for each instance, however.  Details below.

## Usage Examples

### Multiple instances

**NOTE:** It is up to you to specify non-conflicting `webserver_port` parameters for each instance.  Additionally, any Minecraft server configured via the McMyAdmin web interface must choose unique ports.

```
include mcmyadmin

# This will create an instance on port 8080
# with a user/group/home named 'jbeard' and
# an init script called mcmyadmin.number1
mcmyadmin::instance { 'number1':
  webserver_port    => '8080'
  user              => 'jbeard',
  password          => '$ecret',
}

# This will create an instance on port 9090
# with a username, group, and home named 'somegame'
# and an init script called mcmyadmin.somegame
mcmyadmin::instance { 'somegame':
  webserver_port    => '9090'
}
```

### Single Instance

To install a single instance (same behavior as previous versions of this module):

```
include mcmyadmin

# This will create an init script called 'mcmyadmin'
# The 'default' instance is for single instances
mcmyadmin::instance { 'default':
  webserver_port    => '8080',
  user              => 'jdoe',
  group             => 'jdoe',
  password          => 'hunter2',
}
```

## mcmyadmin Class Parameters
#### `install_arch`

This determines which version of the McMyAdmin installer will be downloaded and installed.  Default: '64' on x86_64/Linux systems; '32' on all others.

#### `manage_java`

Boolean: true/false

Whether to install Java or not.  Required for Minecraft.

#### `manage_screen`

Boolean: true/false

Whether to install screen or not.  The init script executes McMyAdmin within a screen session.

#### `manage_mono`

Boolean: true/false

Whether to install mono distro package.  This is only relevant when `install_arch` isn't '64', which only applies to Linux.  Note: EPEL is required on RedHat-like systems.

#### `mono_pkg`

Mono package to be installed.  Default: mono-complete on Debian/Ubuntu. mono-core on RedHat/CentOS (EPEL is required). lang/mono on FreeBSD.

#### `screen_pkg`

Screen package to be installed.
Default: RedHat/Debian: screen;  FreeBSD: sysutils/screen

#### `manage_curl`

Boolean: true/false

Whether to manage the `curl` package or not.  Defaults to `false` on Linux and `true` on FreeBSD.  You probably don't need to change this.  If you're running FreeBSD and are already managing the `curl` package with Puppet, set this parameter to `false`

The `staging` module that this module uses requires `curl` or `wget` to download the remote package, neither of which are installed by default on FreeBSD.

#### `curl_pkg`

curl package to be installed.  `curl` on Linux and `ftp/curl` on FreeBSD.
This parameter doesn't matter if `manage_curl` isn't set to `true`

#### `staging_dir`

Full path to the staging directory (see above). This should be persistent across reboots.

This is `/opt/staging` on Linux (as set by the `staging` module) and `/var/tmp/staging` on FreeBSD (as set by the `mcmyadmin` module)

You probably don't need to change this parameter.

## Defined type: `mcmyadmin::instance`

The title/name you pass to this defined type will, unless other specified using the parameters below, will become the username, group name, password, home directory name, and an init script will be created called `mcmyadmin.${name}`

The name `default` is special, however, to preserve some level of backwards-compatability with single instances.  If a `default` instance is declared, the init script will simply be called `mcmyadmin`

**NOTE:** Unfortunately, due to the way the [staging module](https://github.com/nanliu/puppet-staging) works, each instance will download its own copy of McMyAdmin.

#### `webserver_port`

**Required**. Port for the McMyAdmin web service to listen on.

#### `webserver_addr`

Address for the McMyAdmin web service to listen on. Default: `+` (all interfaces)

#### `password`

The password to use for the McMyAdmin web admin user.  Default: `${name}`

#### `user`

The user to operate as.  A home directory will be created.  Default: `${name}`

#### `group`

Group to create.  The `user` will be a member of this.  Default: `${name}`

#### `homedir`

Path to the home directory.  Default: `/home/${name}`

#### `install_dir`

Where McMyAdmin will be installed.  Default: `${homedir}/McMyAdmin`

#### `mcma_run_args`

Command-line arguments to pass to the MCMA binary when running.

Default: empty

#### `mcma_install_args`

Command-line arguments to pass to the MCMA binary when installing.

Default: empty

## Backwards Compatibility

Previous versions of this module didn't support multiple instances of McMyAdmin on a single server.  To replicate a single instance that you already have in place from a previous application of this module, see the [Single Instance](#usage) example above.  For example, if you had the following previously:

```
include mcmyadmin
```

You would do something like:

```
include mcmyadmin

mcmyadmin::instance { 'default':
  port  => '8080',
}
```

The `default` instance is special in that it will keep a simple init script called `mcmyadmin`, rather than an instance-specific one.

## Limitations

This has been tested on CentOS, Ubuntu, and FreeBSD 9.2 with pkgng.

The `unzip` tool is required, which isn't installed by default on some systems (Debian) and this module doesn't attempt to manage it.

## FreeBSD Notes

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


## Contributing

Contributions very welcome, as well as general comments.

This module is developed independently and not on the behalf of my employer.

Josh Beard (<beard@puppetlabs.com>)

## Copyrights

[McMyAdmin](http://www.mcmyadmin.com/) is Copyright 2013 CubeCoders Limited.

[Minecraft](http://www.minecraft.net/) is Copyright 2009-2013 Mojang.  "Minecraft" is a trademark of Notch Development AB.

Module Copyright 2014 Josh Beard
