require 'spec_helper'

describe 'mcmyadmin' do

  context 'when called with default parameters on centos' do
    let :facts do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'CentOS',
        :operatingsystemrelease => '6.4',
      }
    end

    let :params do
      {
        'manage_mono' => true,
        'manage_curl' => true
      }
    end

    it { should contain_package('mono-core') }
    it { should contain_package('screen') }
    it { should contain_package('curl') }

    it { should contain_class('java') }
  end

  context 'when called on ubuntu without installing extra packages' do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :lsbdistrelease => '12.04',
        :lsbdistcodename => 'precise'
      }
    end

    let :params do
      {
        :manage_mono    => false,
        :manage_curl    => false,
        :manage_screen  => false,
        :manage_java    => false,
        :user           => 'ubuntu_minecraft',
        :group          => 'ubuntu_minecraft',
        :homedir        => '/home/ubuntu_minecraft',
        :install_dir    => '/home/ubuntu_minecraft/mcmyadmin',
        :install_arch   => '64'
      }
    end

    it { should_not contain_package('mono-complete') }
    it { should_not contain_package('screen') }
    it { should_not contain_package('curl') }

    it { should_not contain_class('java') }

    ## Test the 64-bit specific lib stuff
    it do should contain_exec('/opt/staging/mcmyadmin/mcmyadmin_etc.zip') end

    it do should contain_exec('extract mcmyadmin_etc.zip').with(
      'cwd'     => '/usr/local',
      'command' => /mcmyadmin_etc\.zip/
    )
    end

    ## Test deploying the mcmyadmin application
    #it do should contain_exec('/opt/staging/mcmyadmin/mcmyadmin.zip').with(
    #  'command' => /http:\/\/mcmyadmin.com\/Downloads\/MCMA2_glibc25\.zip/
    #)
    #end

    #it do should contain_exec('extract mcmyadmin.zip').with(
    #  'command' => /\/opt\/staging\/mcmyadmin\/mcmyadmin.zip/,
    #  'cwd'     => '/home/ubuntu_minecraft/mcmyadmin',
    #  'user'    => 'ubuntu_minecraft',
    #  'group'   => 'ubuntu_minecraft',
    #  'creates' => '/home/ubuntu_minecraft/mcmyadmin/MCMA2_Linux_x86_64'
    #)
    #end

    #it do should contain_exec('mcmyadmin_install').with(
    #  :command  => /home\/ubuntu_minecraft\/mcmyadmin\/MCMA2_Linux_x86_64/,
    #  :cwd      => '/home/ubuntu_minecraft/mcmyadmin',
    #  :user     => 'ubuntu_minecraft'
    #)
    #end

    describe 'on 32-bit ubuntu' do
      let :params do
        {
          :manage_mono    => false,
          :manage_curl    => false,
          :manage_screen  => false,
          :manage_java    => false,
          :user           => 'ubuntu_minecraft',
          :group          => 'ubuntu_minecraft',
          :homedir        => '/home/ubuntu_minecraft',
          :install_dir    => '/home/ubuntu_minecraft/mcmyadmin',
          :install_arch   => '32'
        }
      end
      it do should_not contain_exec('/opt/staging/mcmyadmin/mcmyadmin_etc.zip') end

      it do should_not contain_exec('extract mcmyadmin_etc.zip').with(
        'cwd'     => '/usr/local',
        'command' => /mcmyadmin_etc\.zip/
      )
      end
    end
  end

  describe 'on FreeBSD' do
    let :facts do
      {
        :osfamily => 'FreeBSD',
        :operatingsystem => 'FreeBSD',
        :operatingsystemrelease => '9.2',
      }
    end

    let :params do
      {
        'manage_mono' => true,
        'manage_curl' => true
      }
    end

    it do should contain_package('lang/mono') end
    it do should contain_package('sysutils/screen') end
    it do should contain_package('ftp/curl') end
    it do should contain_package('java/openjdk7') end

  end
end
