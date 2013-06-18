require 'spec_helper'

module Daodalus
  module DSL
    describe Clause do

      let (:dao) { DAO.new(:animalhouse, :cats) }

      it 'allows you to get the current query' do
        dao.where(:name).eq('Trevor').to_query.should be_a Hash
      end

      it 'allows you to get the current projection' do
        dao.where(:name).eq('Trevor').to_projection.should be_a Hash
      end

      it 'allows you to get the current update' do
        dao.where(:name).eq('Trevor').to_update.should be_a Hash
      end
    end
  end
end
