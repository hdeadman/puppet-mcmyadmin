#
# Parameters class to setup sane defaults
#
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
    $manage_mono  = false
  }
  else {
    $install_arch = '32'
    $manage_mono  = true
  }

  case $::osfamily {
    'RedHat': {
      $mono_pkg       = 'mono-core'
      $screen_pkg     = 'screen'
      $init_script    = '/etc/init.d/mcmyadmin'
      $init_templ     = 'mcmyadmin_init.erb'
      $manage_curl    = false
      $curl_pkg       = 'curl'
      $staging_dir    = undef
    }
    'Debian': {
      $mono_pkg       = 'mono-complete'
      $screen_pkg     = 'screen'
      $init_script    = '/etc/init.d/mcmyadmin'
      $init_templ     = 'mcmyadmin_init.erb'
      $manage_curl    = false
      $curl_pkg       = 'curl'
      $staging_dir    = undef
    }
    'FreeBSD': {
      $mono_pkg       = 'lang/mono'
      $screen_pkg     = 'sysutils/screen'
      $init_script    = '/usr/local/etc/rc.d/mcmyadmin'
      $init_templ     = 'mcmyadmin_freebsd_rc.erb'
      $manage_curl    = true
      $curl_pkg       = 'ftp/curl'
      $staging_dir    = '/var/tmp/staging'
    }
    default: {
      fail("Support for ${::osfamily} not included.")
    }
  }

}
