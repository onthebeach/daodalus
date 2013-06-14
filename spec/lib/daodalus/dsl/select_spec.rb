require 'spec_helper'

module Daodalus
  module DSL
    describe Select do

      let (:dao) { DAO.new(:animalhouse, :cats) }

      before do
        dao.insert('name'  => 'Terry',
                   'paws'  => 3,
                   'likes' => ['tuna', 'catnip'],
                   'foods' => [{'type' => 'dry', 'name' => 'go cat'},
                               {'type' => 'wet', 'name' => 'whiskas'}])
      end

      it 'allows you to get the current query' do
        dao.select(:name).to_query.should be_a Hash
      end

      it 'allows you to get the current projection' do
        dao.select(:name).to_projection.should be_a Hash
      end

      it 'allows you to get the current update' do
        dao.select(:name).to_update.should be_a Hash
      end

      it 'allows the selection of fields to be returned' do
        dao.select(:name, :paws).find_one.value.keys.should eq ['name', 'paws']
      end

      it 'allows the chaining of selects' do
        dao.select(:name).and(:paws).find_one.value.keys.should eq ['name', 'paws']
      end

      it 'allows use of the positional operator' do
        query = dao.select(:foods).by_position.where(:'foods.type').eq('wet')
        result = query.find_one.value
        result.fetch('foods').should eq (['type' => 'wet', 'name' => 'whiskas'])
      end
    end
  end
end
