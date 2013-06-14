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

    it 'merges clauses where possible' do
      q = query.where('paws' => { '$gte' => 3}).where('paws' => {'$lte' => 6})
      q.wheres.should eq ({'paws' => {'$gte'=>3, '$lte'=>6}})
    end

    it 'raises an error if two clauses cannot be merged' do
      expect { query.where('paws' => 3).where('paws' => 4) }.to raise_error InvalidQueryError
    end

  end
end
