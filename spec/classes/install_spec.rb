require 'spec_helper'

RSpec.describe 'iis::install' do
  describe 'compile' do
    it {
      expect(catalogue)
    }
  end

  describe 'install' do
    it {
      is_expected.
          to contain_dism('IIS-WebServer').
                 with(
                     {
                         'ensure' => 'present',
                         'all' => 'true',
                         'before' => 'Service[w3svc]',
                         'notify' => 'Service[w3svc]'
                     }
                 )
    }
    it {
      is_expected.to contain_service('w3svc').with(
                         {
                             'ensure' => 'running',
                             'enable' => 'true',
                         }
                     )
    }
  end
end