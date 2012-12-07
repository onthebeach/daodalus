require 'spec_helper'

module Daodalus
  describe DAO do
    describe '.target' do

      class TestDAO
        extend DAO
        target :cathouse, :kittens
      end

      it 'allows setting of the connection and collection' do
        TestDAO
      end
    end
  end
end
