require 'spec_helper'

module Daodalus
  describe Query do

    let (:dao)   { DAO.new(:animalhouse, :cats) }
    let (:query) { dao.query }

    it 'can have a where clause added to it' do
      query.where(paws: 3).wheres.should eq ({paws: 3})
    end

    it 'can have multiple where clauses added to it' do
      q = query.where('paws' => 3).where('tail' => 'waggy')
      q.wheres.should eq ({'paws' => 3, 'tail' => 'waggy'})
    end

    it 'overwrites previous where clauses if one is added for the same field' do
      q = query.where('paws' => 3).where('paws' => 4)
      q.wheres.should eq ({'paws' => 4})
    end

  end
end
