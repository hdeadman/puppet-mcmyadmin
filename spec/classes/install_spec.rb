require 'spec_helper'

describe 'mcmyadmin::install' do

  let :pre_condition do
    'include mcmyadmin'
  end


  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Ubuntu',
      :operatingsystemrelease => '12.04',
      :lsbdistrelease => '12.04',
      :lsbdistcodename => 'precise'
    }
  end

  it do should contain_file('init_file').with(
    'ensure' => 'file',
    'owner' => 'root',
    'group' => '0'
    )
  end

end
