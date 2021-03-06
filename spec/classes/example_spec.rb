require 'spec_helper'

describe 'blueflood' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "blueflood class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('blueflood::params') }
          it { is_expected.to contain_class('blueflood::install').that_comes_before('blueflood::config') }
          it { is_expected.to contain_class('blueflood::config') }
          it { is_expected.to contain_class('blueflood::service').that_subscribes_to('blueflood::config') }

          it { is_expected.to contain_service('blueflood') }
          it { is_expected.to contain_package('blueflood').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'blueflood class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('blueflood') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
