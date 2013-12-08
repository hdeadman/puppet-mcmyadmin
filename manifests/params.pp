class mcmyadmin::params {
  $architecture   = '64'
  $password       = 'mcmyadmin'
  $user           = 'minecraft'
  $group          = 'minecraft'
  $homedir        = '/home/minecraft'
  $install_dir    = "${homedir}/McMyAdmin"
  $webserver_port = '8080'
  $webserver_addr = '+'

  $mono_pkg = $::osfamily ? {
    'RedHat' => 'mono-core',
    'Debian' => 'mono-complete',
    default  => fail("Don't know how to install mono package for ${::osfamily}"),
  }
}
