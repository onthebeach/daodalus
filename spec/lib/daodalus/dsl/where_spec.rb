require 'spec_helper'

module Daodalus
  module DSL
    describe Where do

      let (:dao) { DAO.new(:animalhouse, :cats) }

      before do
        dao.insert('name' => 'Terry', 'paws' => 3)
      end

      it 'can test for equality' do
        dao.where(:name).eq('Terry').find.should have(1).item
      end

      it 'allows chaining of multiple clauses' do
        dao.where(:name).eq('Terry').and(:paws).eq(3).find_one.should be_some
      end

      it 'excludes documents that do not match' do
        dao.where(:name).eq('Terry').and(:paws).eq(77).find_one.should be_none
      end

    end
  end
end
