require 'spec_helper'

describe 'mcmyadmin::instance_install', :type => :define do
  let :pre_condition do
    'include mcmyadmin'
  end

  let :title do
    'joshbeard'
  end

  describe 'single instance install' do
    let :title do
      'default'
    end
    let :facts do
      {
        :osfamily               => 'RedHat',
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '6.4',
        :architecture           => 'x86_64',
        :kernel                 => 'Linux'
      }
    end
    let :params do
      {
        :webserver_port       => '8080',
        :password             => 'secret',
        :user                 => 'minecraft',
        :group                => 'minecraft',
        :mcma_install_args    => '',
        :webserver_addr       => '+',
        :install_arch         => '64',
        :install_dir          => '/home/minecraft/McMyAdmin'
      }
    end
    it { should contain_file('default_init_file').with(
      :ensure       => 'file',
      :path         => '/etc/init.d/mcmyadmin',
      :owner        => 'root',
      :group        => '0',
      :mode         => '0755',
      :content      => /mcmyadmin_user="minecraft"/
    ) }

    it { should contain_service('mcmyadmin').with(
      :ensure       => 'running',
      :enable       => true
    ) }
  end

  describe 'creating an mcmyadmin instance' do
    context 'on CentOS' do
      let :facts do
        {
          :osfamily               => 'RedHat',
          :operatingsystem        => 'CentOS',
          :operatingsystemrelease => '6.4',
          :architecture           => 'x86_64',
          :kernel                 => 'Linux'
        }
      end
      let :params do
        {
          :webserver_port       => '8080',
          :password             => 'secret',
          :user                 => 'user_josh',
          :group                => 'group_josh',
          :mcma_install_args    => '',
          :webserver_addr       => '+',
          :install_arch         => '64',
          :install_dir          => '/home/josh/McMyAdmin'
        }
      end

      it { should contain_exec('/opt/staging/mcmyadmin/joshbeard_mcmyadmin.zip').with(
        :command      => /http:\/\/mcmyadmin\.com\/Downloads\/MCMA2_glibc25\.zip/
      ) }

      it { should contain_exec('extract joshbeard_mcmyadmin.zip').with(
        :command      => /\/opt\/staging\/mcmyadmin\/joshbeard_mcmyadmin\.zip/,
        :cwd          => '/home/josh/McMyAdmin',
        :user         => 'user_josh',
        :group        => 'group_josh',
        :creates      => '/home/josh/McMyAdmin/MCMA2_Linux_x86_64'
      ) }

      it { should contain_exec('joshbeard_mcmyadmin_install').with(
        :command      => /home\/josh\/McMyAdmin\/MCMA2_Linux_x86_64.*\-setpass secret/,
        :cwd          => '/home/josh/McMyAdmin',
        :user         => 'user_josh'
      ) }

      it { should contain_file('joshbeard_init_file').with(
        :ensure       => 'file',
        :path         => '/etc/init.d/mcmyadmin.joshbeard',
        :owner        => 'root',
        :group        => '0',
        :mode         => '0755',
        :content      => /mcmyadmin_user="user_josh"/
      ) }

      it { should contain_service('mcmyadmin.joshbeard').with(
        :ensure       => 'running',
        :enable       => true
      ) }

      it { should contain_file_line('joshbeard_webserver_port').with(
        :path         => '/home/josh/McMyAdmin/McMyAdmin.conf',
        :line         => 'Webserver.Port=8080'
      ) }

      it { should contain_file_line('joshbeard_webserver_addr').with(
        :path         => '/home/josh/McMyAdmin/McMyAdmin.conf',
        :line         => 'Webserver.IPBinding=+'
      ) }

      it { should contain_file_line('joshbeard_webserver_addr_local').with(
        :path         => '/home/josh/McMyAdmin/McMyAdmin.conf',
        :line         => 'Server.Address=localhost:+'
      ) }
    end
  end

  describe 'freebsd instance install' do
    let :title do
      'freebsdmc'
    end
    let :facts do
      {
        :osfamily               => 'FreeBSD',
        :operatingsystem        => 'FreeBSD',
        :operatingsystemrelease => '10.0',
        :architecture           => 'x86_64',
        :kernel                 => 'FreeBSD'
      }
    end
    let :params do
      {
        :webserver_port       => '8080',
        :password             => 'secret',
        :user                 => 'fminecraft',
        :group                => 'fminecraft',
        :mcma_install_args    => '',
        :webserver_addr       => '+',
        :install_arch         => '64',
        :install_dir          => '/home/minecraft/McMyAdmin'
      }
    end
    it { should contain_file('freebsdmc_init_file').with(
      :ensure       => 'file',
      :path         => '/usr/local/etc/rc.d/mcmyadmin.freebsdmc',
      :owner        => 'root',
      :group        => '0',
      :mode         => '0755',
      :content      => /mcmyadmin_user="fminecraft"/
    ) }
  end
end
