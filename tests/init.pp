include mcmyadmin

mcmyadmin::instance { 'default':
  webserver_port => '8080',
}

mcmyadmin::instance { 'beard':
  webserver_port => '9090',
}


mcmyadmin::instance { 'blackball':
  webserver_port => '8181',
  user           => 'lester',
  group          => 'testing',
  homedir        => '/home/kaboom',
  install_dir    => '/home/kaboom/mc',
  password       => 'hunter2',
}
