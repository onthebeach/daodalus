require 'spec_helper'

module Daodalus
  describe Configuration do
    it 'loads the config' do
      Configuration.config['conn1']['database'].should eq 'daodalus_test_1'
    end
  end
end
