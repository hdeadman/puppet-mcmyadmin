class mcmyadmin::params {
  $password       = 'mcmyadmin'
  $user           = 'minecraft'
  $group          = 'minecraft'
  $homedir        = '/home/minecraft'
  $install_dir    = "${homedir}/McMyAdmin"
  $webserver_port = '8080'
  $webserver_addr = '+'

  if ($::architecture == 'x86_64') and ($::kernel == 'Linux') {
    $install_arch = '64'
  }
  else {
    $install_arch = '32'
  }

  $mono_pkg = $::osfamily ? {
    'RedHat' => 'mono-core',
    'Debian' => 'mono-complete',
    default  => fail("Don't know how to install mono package for ${::osfamily}"),
  }
}
