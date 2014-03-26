#
# Example for FreeBSD.  The only unique thing is that we're using
# 'pkgng' as the package provider.  If you wanted to do this globally, you'd
# probably put it in site.pp
#
# This will create three instances
#
Package {
  provider => 'pkgng',
}

include mcmyadmin

mcmyadmin::instance { 'default':
  webserver_port => '8080',
}

mcmyadmin::instance { 'beard':
  webserver_port => '9090',
}


mcmyadmin::instance { 'blackball':
  webserver_port => '8181',
  user           => 'lester',
  group          => 'testing',
  homedir        => '/home/kaboom',
  install_dir    => '/home/kaboom/mc',
  password       => 'hunter2',
}
