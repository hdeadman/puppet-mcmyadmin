#
# Class to handle the fetching and installation of mcmyadmin
#
define mcmyadmin::instance_install (
  $install_dir,
  $user,
  $group,
  $password,
  $mcma_install_args,
  $webserver_port,
  $webserver_addr,
  $install_arch,
) {

  if ! defined(Class['mcmyadmin']) {
    fail('You must include the mcmyadmin base class before creating mcmyadmin instances')
  }

  case $install_arch {
    '64': {
      $download_src   = 'http://mcmyadmin.com/Downloads/MCMA2_glibc25.zip'
      $install_cmd    = "${install_dir}/MCMA2_Linux_x86_64"
      $mcmyadmin_exec = 'MCMA2_Linux_x86_64'
    }
    '32': {
      $download_src   = 'http://mcmyadmin.com/Downloads/MCMA2-Latest.zip'
      $install_cmd    = "/usr/bin/env mono ${install_dir}/McMyAdmin.exe"
      $mcmyadmin_exec = 'McMyAdmin.exe'
    }
    default: {
      fail("Unknown install_arch: ${install_arch}. Must be '64' or '32'.")
    }
  }

  # For backwards-compatibility, if this is the 'default' instance, set an
  # init script simply called 'mcmyadmin'
  if ($name == 'default') {
    $init_script  = $mcmyadmin::params::init_script
    $service_name = 'mcmyadmin'
  }
  else {
    $init_script  = "${mcmyadmin::params::init_script}.${name}"
    $service_name = "mcmyadmin.${name}"
  }

  staging::file { "${title}_mcmyadmin.zip":
    source => $download_src,
    }->
    staging::extract { "${title}_mcmyadmin.zip":
      target  => $install_dir,
      user    => $user,
      group   => $group,
      creates => "${install_dir}/${mcmyadmin_exec}",
      }~>
      exec { "${title}_mcmyadmin_install":
        command     => "${install_cmd} ${mcma_install_args} -nonotice -setpass ${password} -configonly",
        user        => $user,
        refreshonly => true,
        logoutput   => true,
        cwd         => $install_dir,
        require     => Class['mcmyadmin'],
      }

      file_line { "${title}_webserver_port":
        path    => "${install_dir}/McMyAdmin.conf",
        line    => "Webserver.Port=${webserver_port}",
        match   => 'Webserver.Port=.*',
        require => Exec["${title}_mcmyadmin_install"],
      }

      file_line { "${title}_webserver_addr":
        path    => "${install_dir}/McMyAdmin.conf",
        line    => "Webserver.IPBinding=${webserver_addr}",
        match   => 'Webserver.IPBinding=.*',
        require => Exec["${title}_mcmyadmin_install"],
      }

      file_line { "${title}_webserver_addr_local":
        path    => "${install_dir}/McMyAdmin.conf",
        line    => "Server.Address=localhost:${webserver_addr}",
        match   => 'Server.Address=localhost:.*',
        require => Exec["${title}_mcmyadmin_install"],
      }

      file { "${name}_init_file":
        ensure     => 'file',
        path       => $init_script,
        owner      => 'root',
        group      => '0',
        mode       => '0755',
        content    => template("mcmyadmin/${mcmyadmin::params::init_templ}"),
        require    => File_line["${title}_webserver_addr_local"],
      }

      service { $service_name:
        ensure  => 'running',
        enable  => true,
        require => File["${name}_init_file"],
      }
}
