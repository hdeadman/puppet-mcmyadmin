## Declare the module, accepting all defaults
include mcmyadmin

## Declare the module, specifying a port to run the McMyAdmin web server on
#class { 'mcmyadmin':
#  webserver_port => '9090',
#}

## Declare the module, but don't manage the installation of Java or Mono and
## set a different install path
#class { 'mcmyadmin':
#  user        => 'mcmyadmin',
#  group       => 'mcmyadmin',
#  homedir     => '/home/mcmyadmin',
#  install_dir => '/home/mcmyadmin/mcmyadmin',
#  manage_java => false,
#  manage_mono => false,
#}
