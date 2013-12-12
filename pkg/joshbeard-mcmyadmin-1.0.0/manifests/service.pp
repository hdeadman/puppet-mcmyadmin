class mcmyadmin::service inherits mcmyadmin {
  file { 'init_file':
    ensure  => file,
    path    => '/etc/init.d/mcmyadmin',
    owner   => 'root',
    group   => '0',
    mode    => '0755',
    content => template('mcmyadmin/mcmyadmin_init.erb'),
    require => Exec['mcmyadmin_install'],
  }

  service { 'mcmyadmin':
    ensure  => running,
    enable  => true,
    require => File['init_file'],
  }
}
