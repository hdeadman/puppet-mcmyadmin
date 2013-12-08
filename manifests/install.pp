class mcmyadmin::install inherits mcmyadmin {

  if $::mcmyadmin::architecture == '64' {
    $download_src = 'http://mcmyadmin.com/Downloads/MCMA2_glibc25.zip'
    $install_cmd  = "${::mcmyadmin::install_dir}/MCMA2_Linux_x86_64"

    staging::file { 'mcmyadmin_etc.zip':
      source => 'http://mcmyadmin.com/Downloads/etc.zip',
    }->
    staging::extract { 'mcmyadmin_etc.zip':
      target  => '/usr/local',
      user    => 'root',
      group   => '0',
      creates => '/usr/local/etc/mono',
      before  => Staging::File['mcmyadmin.zip'],
    }
  }
  else {
    $download_src = 'http://mcmyadmin.com/Downloads/MCMA2-Latest.zip'
    $install_cmd  = 'mono McMyAdmin.exe'
  }

  staging::file { 'mcmyadmin.zip':
    source => $download_src,
  }->
  staging::extract { 'mcmyadmin.zip':
    target  => $::mcmyadmin::install_dir,
    user    => $::mcmyadmin::user,
    group   => $::mcmyadmin::group,
    creates => "${::mcmyadmin::install_dir}/MCMA2_Linux_x86_64",
  }~>
  exec { 'mcmyadmin_install':
    command     => "${install_cmd} -nonotice -setpass ${::mcmyadmin::password} -configonly",
    user        => $::mcmyadmin::user,
    refreshonly => true,
    logoutput   => true,
    cwd         => $::mcmyadmin::install_dir,
  }

  file { 'init_file':
    ensure   => file,
    path     => '/etc/init.d/mcmyadmin',
    owner    => 'root',
    group    => '0',
    mode     => '0755',
    content  => template('mcmyadmin/mcmyadmin_init.erb'),
  }

  file_line { 'webserver_port':
    path    => "${::mcmyadmin::install_dir}/McMyAdmin.conf",
    line    => "Webserver.Port=${::mcmyadmin::webserver_port}",
    match   => 'Webserver.Port=.*',
    require => Exec['mcmyadmin_install'],
  }

  file_line { 'webserver_addr':
    path    => "${::mcmyadmin::install_dir}/McMyAdmin.conf",
    line    => "Webserver.IPBinding=${::mcmyadmin::webserver_addr}",
    match   => 'Webserver.IPBinding=.*',
    require => Exec['mcmyadmin_install'],
  }


  service { 'mcmyadmin':
    ensure  => running,
    enable  => true,
    require => File['init_file'],
  }
}
