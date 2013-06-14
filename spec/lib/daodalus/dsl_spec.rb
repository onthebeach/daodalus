require 'spec_helper'

module Daodalus
  describe DSL do

    let (:dao) { DAO.new(:animalhouse, :cats) }

    it 'can perform queries with a where clause' do
      dao.where(:paws).eq(-1).find.to_a.should eq []
    end
  end
end
