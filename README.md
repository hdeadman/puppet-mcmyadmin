#puppet-mcmyadmin

![Minecraft](http://i.imgur.com/AOJ7jxN.png)

###Overview

This module will install [McMyAdmin](http://www.mcmyadmin.com/), a Minecraft control panel.

###Details

McMyAdmin uses Mono, which is installed using McMyAdmin's goofy method with the 64-bit version (in a strange manner).  If you install McMyAdmin 32-bit, your distro package will be installed.

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
####`architecture`

This determines which version of the McMyAdmin installer will be downloaded and installed.  Default: `64`

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

Whether to install mono distro package.  This is only relevant when `architecture` isn't '64', which only applies to Linux.  Note: EPEL is required on RedHat-like systems.

####`mono_pkg`

Mono package to be installed.  Default: mono-complete on Debian/Ubuntu. mono-core on RedHat/CentOS (EPEL is required)

###Limitations

Right now, this module is known to work with recent versions of CentOS, Ubuntu, and Debian.

###TODO

* Better rspec testing
* Cleanup `mcmyadmin::install`

###Contributing

Contributions very welcome, as well as general comments.

This module is developed independently and not on the behalf of my employer.

Josh Beard (<beard@puppetlabs.com>)


