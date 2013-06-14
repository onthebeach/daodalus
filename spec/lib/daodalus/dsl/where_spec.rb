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

      it 'can test for inequality' do
        dao.where(:name).ne('Jennifer').find_one.should be_some
        dao.where(:name).ne('Terry').find_one.should be_none
      end

      it 'implements #lt' do
        dao.where(:paws).lt(4).find_one.should be_some
        dao.where(:paws).lt(3).find_one.should be_none
      end

      it 'implements #gt' do
        dao.where(:paws).gt(4).find_one.should be_none
        dao.where(:paws).gt(2).find_one.should be_some
      end

      it 'implements #lte' do
        dao.where(:paws).lte(3).find_one.should be_some
        dao.where(:paws).lte(2).find_one.should be_none
      end

      it 'implements #gte' do
        dao.where(:paws).gte(3).find_one.should be_some
        dao.where(:paws).gte(4).find_one.should be_none
      end

      it 'implements #in' do
        dao.where(:paws).in(3, 5).find_one.should be_some
        dao.where(:paws).in(4, 1).find_one.should be_none
      end

      it 'implements #nin' do
        dao.where(:paws).nin(2, 5).find_one.should be_some
        dao.where(:paws).nin(4, 3).find_one.should be_none
      end

    end
  end
end
