require 'spec_helper'

describe 'mcmyadmin::instance', :type => :define do
  let :pre_condition do
    'include mcmyadmin'
  end

  let :title do
    'joshbeard'
  end

  describe 'something' do
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
          :homedir              => '/home/josh'
        }
      end

      it { should contain_class('mcmyadmin::params') }

      it { should contain_user('user_josh').with(
        :ensure       => 'present',
        :home         => '/home/josh',
        :gid          => 'group_josh'
      ) }

      it { should contain_group('group_josh') }

      it { should contain_file('/home/josh').with(
        :ensure       => 'directory',
        :owner        => 'user_josh',
        :group        => 'group_josh',
        :mode         => '0755'
      ) }

      it { should contain_file('/home/josh/McMyAdmin').with(
        :ensure       => 'directory',
        :owner        => 'user_josh',
        :group        => 'group_josh',
        :mode         => '0755'
      ) }

      it { should contain_mcmyadmin__instance_install('joshbeard').with(
        :install_dir    => '/home/josh/McMyAdmin',
        :user           => 'user_josh',
        :group          => 'group_josh',
        :password       => 'secret',
        :webserver_port => '8080',
        :webserver_addr => '+',
        :install_arch   => '64'
      ) }
    end
  end
end
