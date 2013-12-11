# Class mcmyadmin.  See README.md for documentation
class mcmyadmin (
  $install_arch   = $mcmyadmin::params::install_arch,
  $password       = $mcmyadmin::params::password,
  $user           = $mcmyadmin::params::user,
  $group          = $mcmyadmin::params::group,
  $homedir        = $mcmyadmin::params::homedir,
  $install_dir    = $mcmyadmin::params::install_dir,
  $webserver_port = $mcmyadmin::params::webserver_port,
  $webserver_addr = $mcmyadmin::params::webserver_addr,
  $manage_java    = true,
  $manage_screen  = true,
  $manage_mono    = true,
  $mono_pkg       = $mcmyadmin::params::mono_pkg,
) inherits mcmyadmin::params {

  validate_string($install_arch)
  validate_string($password)
  validate_string($user)
  validate_string($group)
  validate_absolute_path($homedir)
  validate_absolute_path($install_dir)
  validate_string($webserver_port)
  validate_string($webserver_addr)
  validate_bool($manage_java)
  validate_bool($manage_screen)
  validate_bool($manage_mono)
  validate_string($mono_pkg)

  user { $user:
    ensure     => present,
    managehome => true,
    home       => $homedir,
    gid        => $group,
  }

  group { $group:
    ensure => present,
  }

  file { $homedir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  file { $install_dir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  if $manage_java {
    class { 'java':
      distribution => 'jre',
      before       => Service['mcmyadmin']
    }
  }

  if $manage_screen {
    package { 'screen':
      before => Service['mcmyadmin']
    }
  }

  if $manage_mono {
    package { $mono_pkg:
      ensure => installed,
      before => Exec['mcmyadmin_install'],
    }
  }

  anchor { 'mcmyadmin::begin': }->
  class { '::mcmyadmin::install': }->
  class { '::mcmyadmin::service': }->
  anchor { 'mcmyadmin::end': }

}
