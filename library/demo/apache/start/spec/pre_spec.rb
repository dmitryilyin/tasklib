require 'spec_helper'
require 'rubygems'
require 'facter'

describe 'apache package' do
  let(:package_name) do
    case Facter.value(:osfamily)
      when 'RedHat' then 'httpd'
      when 'Debian' then 'apache2'
    end
  end
  it { package(package_name).should be_installed }
end

describe 'apache service' do
  let(:service_name) do
    case Facter.value(:osfamily)
      when 'RedHat' then 'httpd'
      when 'Debian' then 'apache2'
    end
  end
  it { service(service_name).should_not be_running }
  it { service(service_name).should_not be_enabled }
end
