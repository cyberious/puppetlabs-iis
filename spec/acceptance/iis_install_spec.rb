require 'spec_helper_acceptance'

RSpec.describe 'iis::install' do

  describe 'install IIS' do
    it {
      pp = <<-IIS
      class {'iis::install':}
      IIS
      apply_manifest_on(default, pp)
    }
    describe windows_feature('IIS-WebServer') do
      it { should be_installed.by("dism") }
    end
    describe service('w3svc') do
      it { should be_running }
    end
  end

  describe 'fact' do
    it 'should report back a version' do
      distmoduledir = on(default, "echo #{default['distmoduledir']}").raw_output.chomp
      facter_opts = {:environment => {'FACTERLIB' => "#{distmoduledir}/iis/lib/facter"}}
      fact_on(default, 'iis_version', facter_opts) do |result|
        expect(result.raw_output).to match(/^\d\.\d/)
      end
    end
  end
end