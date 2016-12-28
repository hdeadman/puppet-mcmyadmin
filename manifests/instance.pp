define mcmyadmin::instance (
  $webserver_port,
  $webserver_addr     = '+',
  $password           = $name,
  $user               = $name,
  $group              = $name,
  $user_shell         = '/usr/sbin/nologin',
  $homedir            = "/home/${name}",
  $install_dir        = 'home',
  $mcma_install_args  = '',
  $mcma_run_args      = '',
) {

  include mcmyadmin::params

  # Do some sanitization of parameters
  # Should we really be sanitizing password? Probably should just validate and reject
  $instance_password    = regsubst($password,'[^0-9a-zA-Z_]+','', 'G')
  $instance_user        = regsubst($user,'[^0-9a-zA-Z_]+','', 'G')
  $instance_group       = regsubst($group,'[^0-9a-zA-Z_]+','', 'G')
  $instance_homedir     = regsubst($homedir,'[^0-9a-zA-Z_\/\-\.]+','', 'G')
  $instance_name        = regsubst($title,'[^0-9a-zA-Z_]+','', 'G')
  
  $instance_install_dir = $install_dir ? {
    'home'  => regsubst("${instance_homedir}/McMyAdmin",'[^0-9a-zA-Z_\/\-\.]+','', 'G'),
    default => regsubst($install_dir,'[^0-9a-zA-Z_\/\-\.]+','', 'G')
  }

  validate_string($instance_password)
  validate_string($instance_user)
  validate_string($instance_group)
  validate_absolute_path($instance_homedir)
  validate_absolute_path($instance_install_dir)
  validate_string($webserver_port)
  validate_string($webserver_addr)
  validate_string($mcma_install_args)
  validate_string($mcma_run_args)
  validate_string($user_shell)

  user { $instance_user:
    ensure     => present,
    managehome => true,
    home       => $instance_homedir,
    gid        => $instance_group,
    shell      => $user_shell,
  }

  group { $instance_group:
    ensure  => 'present',
  }

  file { $instance_homedir:
    ensure     => 'directory',
    owner => $instance_user,
    group => $instance_group,
    mode  => '0755',
  }

  file { $instance_install_dir:
    ensure => 'directory',
    owner  => $instance_user,
    group  => $instance_group,
    mode   => '0755',
  }

  mcmyadmin::instance_install { $instance_name:
    install_dir       => $instance_install_dir,
    user              => $instance_user,
    group             => $instance_group,
    password          => $instance_password,
    mcma_install_args => $mcma_install_args,
    webserver_port    => $webserver_port,
    webserver_addr    => $webserver_addr,
    install_arch      => $mcmyadmin::params::install_arch,
    require           => File[$instance_install_dir],
    use_systemd       => $mcmyadmin::params::use_systemd,
  }

}
