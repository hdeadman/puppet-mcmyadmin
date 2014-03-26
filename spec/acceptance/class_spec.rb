require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'mcmyadmin class:', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  describe 'with reasonably default parameters' do
    it 'should run successfully' do
      pp = <<-EOS
        include mcmyadmin
        mcmyadmin::instance { 'blackball':
          webserver_port      => '8080',
        }
      EOS

      # Apply twice to ensure no errors the second time.
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stderr).to eq("")
      end
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stderr).to eq("")
        expect(r.exit_code).to be_zero
      end

    end

    if fact('architecture') !~ /64/
      describe package($mono_package) do
      it { should be_installed }
      end
    end

    describe package($curl_package) do
      it { should be_installed }
    end

    describe package($screen_package) do
      it { should be_installed }
    end

    describe user('blackball') do
      it { should exist }
      it { should belong_to_group 'blackball' }
      it { should have_home_directory '/home/blackball' }
    end

    describe group('blackball') do
      it { should exist }
    end

    describe file('/home/blackball') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'blackball' }
      it { should be_grouped_into 'blackball' }
    end

    describe file('/home/blackball/McMyAdmin') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'blackball' }
      it { should be_grouped_into 'blackball' }
    end

    describe file('/home/blackball/McMyAdmin/McMyAdmin.conf') do
      it { should be_file }
      its(:content) { should match /Webserver\.Port=8080/ }
      its(:content) { should match /Webserver\.IPBinding=\+/ }
    end

    describe service('mcmyadmin.blackball') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(8080) do
      it { should be_listening.with('tcp') }
    end

    describe command('su blackball -c "screen -ls|grep mcmyadmin"') do
      it { should return_exit_status 0 }
    end
  end

  describe 'with some custom parameters' do
    it 'should run successfully' do
      pp = <<-EOS
        include mcmyadmin
        mcmyadmin::instance { 'lovely':
          webserver_port      => '9090',
          password            => 'hunter2',
          user                => 'lester',
          group               => 'testing',
          homedir             => '/home/kaboom',
          install_dir         => '/home/kaboom/mc',
        }
      EOS

      # Apply twice to ensure no errors the second time.
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stderr).to eq("")
      end

    end
    describe user('lester') do
      it { should exist }
      it { should belong_to_group 'testing' }
      it { should have_home_directory '/home/kaboom' }
    end

    describe group('testing') do
      it { should exist }
    end

    describe file('/home/kaboom') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'lester' }
      it { should be_grouped_into 'testing' }
    end

    describe file('/home/kaboom/mc') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'lester' }
      it { should be_grouped_into 'testing' }
    end

    describe file('/home/kaboom/mc/McMyAdmin.conf') do
      it { should be_file }
      its(:content) { should match /Webserver\.Port=9090/ }
      its(:content) { should match /Webserver\.IPBinding=\+/ }
    end

    describe service('mcmyadmin.lovely') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(9090) do
      it { should be_listening.with('tcp') }
    end

    describe command('su lester -c "screen -ls|grep mcmyadmin"') do
      it { should return_exit_status 0 }
    end
  end
end
