require 'spec_helper_acceptance'

RSpec.describe 'iis_application' do

  describe 'My New Site' do
    it 'apply manifest' do
      pp = <<-IIS_SITE
include iis::install
file{['C:\\inetpub\\basicSiteApp','C:\\inetpub\\basicApp']:
  ensure => directory,
}
iis_site{'basicSiteApp':
  ensure   => 'started',
  app_pool => 'DefaultAppPool',
  ip       => '*',
  path     => 'C:\\inetpub\\basicSiteApp',
  port     => 8081,
  protocol => 'http',
  require  => Class['iis::install'],
}
iis_application{'basicApplication':
  app_pool => 'DefaultAppPool',
  site => 'basicSiteApp',
  path     => 'C:\\inetpub\\basicApp',
  require  => Class['iis::install'],
}
      IIS_SITE
      apply_manifest pp
    end

    describe iis_website('basicSiteApp') do
      it { should exist }
      it { should be_running }
      it { should have_site_application('basicApplication')}
    end
  end


end