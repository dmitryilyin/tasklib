require 'spec_helper'
require 'deploy'

describe Tasklib::Utils do
  context 'symbolize_hash' do
    it 'should convert hash keys to symbols' do
      hash = { 'a' => 1, 'b' => 2 }
      Tasklib::Utils.symbolize_hash hash
      hash.should == { :a => 1, :b => 2 }
    end
  end
end



