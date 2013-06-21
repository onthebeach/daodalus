require 'spec_helper'

module Daodalus
  module DSL
    describe Update do

      let (:dao) { DAO.new(:animalhouse, :cats) }

      before do
        dao.insert('name'  => 'Terry',
                   'paws'  => 3,
                   'likes' => ['tuna', 'catnip'],
                   'lives' => [1,2,3,4,5,6,7,8,9],
                   'foods' => [{'type' => 'dry', 'name' => 'go cat'},
                               {'type' => 'wet', 'name' => 'whiskas'}])
      end

      it 'can perform upserts' do
        dao.set(paws: 3).where(:name).eq('Charlie').upsert
        dao.where(:name).eq('Charlie').find_one.value.merge('_id' => 1).should eq ({
          '_id' => 1,
          "name"=>"Charlie", "paws"=>3
        })
      end

      it 'can perform find_and_modifys' do
        dao.inc(:paws).where(:name).eq('Terry').find_and_modify
        dao.where(:name).eq('Terry').find_one.value.merge('_id' => 1).should eq ({
          '_id' => 1,
          "name"=>"Terry", "paws"=>4, "likes"=>["tuna", "catnip"], "lives"=>[1, 2, 3, 4, 5, 6, 7, 8, 9], "foods"=>[{"type"=>"dry", "name"=>"go cat"}, {"type"=>"wet", "name"=>"whiskas"}]
        })
      end

      it 'implements #set' do
        dao.set(name: 'Terrence', paws: 2).update
        dao.find_one.value.fetch('paws').should eq 2
        dao.find_one.value.fetch('name').should eq 'Terrence'
      end

      it 'implements #unset' do
        dao.unset(:name, :likes).update
        dao.find_one.value.fetch('names', nil).should be_nil
        dao.find_one.value.fetch('likes', nil).should be_nil
      end

      it 'implements #inc' do
        dao.inc(:paws).update
        dao.find_one.value.fetch('paws').should eq 4
      end

      it 'implements #dec' do
        dao.dec(:paws, 2).update
        dao.find_one.value.fetch('paws').should eq 1
      end

      it 'implements #rename' do
        dao.rename(:paws, :feet).update
        dao.find_one.value.fetch('feet').should eq 3
      end

      it 'implements #push' do
        dao.push(:likes, 'food').update
        dao.push(:likes, 'Marxist political economics', 'cake').update
        dao.find_one.value.fetch('likes').should include 'Marxist political economics'
        dao.find_one.value.fetch('likes').should include 'cake'
        dao.find_one.value.fetch('likes').should include 'food'
      end

      it 'implements #pushAll' do
        dao.push_all(:likes, ['Marxist political economics', 'cake']).update
        dao.find_one.value.fetch('likes').should include 'Marxist political economics'
        dao.find_one.value.fetch('likes').should include 'cake'
      end

      it 'implements #add_to_set' do
        dao.add_to_set(:likes, 'cake').update
        dao.add_to_set(:likes, 'tuna', 'cake', 'cake').update
        dao.find_one.value.fetch('likes').should eq ['tuna', 'catnip', 'cake']
      end

      it 'implements #add_each_to_set' do
        dao.add_each_to_set(:likes, ['tuna', 'cake', 'cake']).update
        dao.find_one.value.fetch('likes').should eq ['tuna', 'catnip', 'cake']
      end

      it 'implements #pop_first' do
        dao.pop_first(:likes).update
        dao.find_one.value.fetch('likes').should eq ['catnip']
      end

      it 'implements #pop_last' do
        dao.pop_last(:likes).update
        dao.find_one.value.fetch('likes').should eq ['tuna']
      end

      it 'implements #pull' do
        dao.pull(:likes, 'tuna').update
        dao.find_one.value.fetch('likes').should eq ['catnip']
      end

      it 'allows passing multipl values to #pull' do
        dao.pull(:likes, 'tuna', 'catnip').update
        dao.find_one.value.fetch('likes').should eq []
      end

      it 'implements #pull_all' do
        dao.pull_all(:likes, ['catnip', 'tuna']).update
        dao.find_one.value.fetch('likes').should eq []
      end

    end
  end
end
