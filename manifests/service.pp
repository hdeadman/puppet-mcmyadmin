#
# Class to handle the mcmyadmin service
#
class mcmyadmin::service inherits mcmyadmin {
  $install_cmd = $mcmyadmin::install::install_cmd

  file { 'init_file':
    ensure      => file,
    path        => $mcmyadmin::init_script,
    owner       => 'root',
    group       => '0',
    mode        => '0755',
    content     => template("mcmyadmin/${mcmyadmin::init_templ}"),
    require     => Exec['mcmyadmin_install'],
  }

  service { 'mcmyadmin':
    ensure  => running,
    enable  => true,
    require => File['init_file'],
  }
}
