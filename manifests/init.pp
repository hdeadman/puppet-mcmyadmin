class mcmyadmin (
  $architecture   = $mcmyadmin::params::architecture,
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
) inherits mcmyadmin::params {

  validate_string($architecture)
  validate_string($password)
  validate_string($user)
  validate_string($group)
  validate_absolute_path($homedir)
  validate_absolute_path($install_dir)

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
  anchor { 'mcmyadmin::end': }

}
