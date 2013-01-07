require 'spec_helper'

module Daodalus
  describe Configuration do
    it 'loads the config' do
      Configuration.config['cathouse']['database'].should eq 'daodalus'
    end
  end
end
