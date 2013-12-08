#puppet-mcmyadmin

###Overview

This module will install [McMyAdmin](http://www.mcmyadmin.com/), a Minecraft control panel.

###Details

McMyAdmin uses Mono, which is installed with the 64-bit version (in a strange manner).  If you install McMyAdmin 32-bit, you will need to install Mono on your own.

Minecraft itself requires Java, which can optionally be installed with this module by using the `manage_java` parameter.

This module includes an init script, which will launch McMyAdmin from within a screen session.  This module can optionally install screen by using the `manage_screen` parameter.

###Usage
####Basic, default use:

```
include mcmyadmin
```

Example of running with the webserver on a custom port:

```
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

###Limitations

Right now, this module is known to work with recent versions of CentOS, Ubuntu, and Debian.