require 'spec_helper'

describe service 'memcached' do
  it { should be_running }
  it { should be_enabled }
end
