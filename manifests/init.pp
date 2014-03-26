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
  $manage_mono    = $mcmyadmin::params::manage_mono,
  $mono_pkg       = $mcmyadmin::params::mono_pkg,
  $screen_pkg     = $mcmyadmin::params::screen_pkg,
  $manage_curl    = $mcmyadmin::params::manage_curl,
  $curl_pkg       = $mcmyadmin::params::curl_pkg,
  $staging_dir    = $mcmyadmin::params::staging_dir,
  $mcma_install_args  = '',
  $mcma_run_args      = '',
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
  validate_string($mcma_install_args)
  validate_string($mcma_run_args)

  if $manage_java {
    if $::osfamily == 'FreeBSD' {
      package { 'java/openjdk7':
        ensure => 'installed',
      }
    }
    else {
      class { 'java':
        distribution => 'jre',
      }
    }
  }

  if $manage_screen {
    package { $screen_pkg:
      ensure => 'installed',
    }
  }

  if $manage_mono {
    package { $mono_pkg:
      ensure => 'installed',
    }
  }

  if $manage_curl {
    package { $curl_pkg:
      ensure => 'installed',
    }
  }

  if $staging_dir {
    class { 'staging':
      path  => $staging_dir,
    }
  }

  if $::mcmyadmin::install_arch == '64' {
    $download_src   = 'http://mcmyadmin.com/Downloads/MCMA2_glibc25.zip'
    $install_cmd    = "${::mcmyadmin::install_dir}/MCMA2_Linux_x86_64"
    $mcmyadmin_exec = 'MCMA2_Linux_x86_64'

    staging::file { 'mcmyadmin_etc.zip':
      source => 'http://mcmyadmin.com/Downloads/etc.zip',
    }->
    staging::extract { 'mcmyadmin_etc.zip':
      target  => '/usr/local',
      user    => 'root',
      group   => '0',
      creates => '/usr/local/etc/mono',
    }
  }
  else {
    $download_src   = 'http://mcmyadmin.com/Downloads/MCMA2-Latest.zip'
    $install_cmd    = "/usr/bin/env mono ${::mcmyadmin::install_dir}/McMyAdmin.exe"
    $mcmyadmin_exec = 'McMyAdmin.exe'
  }

}
