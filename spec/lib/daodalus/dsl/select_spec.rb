require 'spec_helper'

module Daodalus
  module DSL
    describe Select do

      let (:dao) { DAO.new(:animalhouse, :cats) }

      before do
        dao.insert('name'  => 'Terry',
                   'paws'  => 3,
                   'likes' => ['tuna', 'catnip'],
                   'lives' => [1,2,3,4,5,6,7,8,9],
                   'foods' => [{'type' => 'dry', 'name' => 'go cat'},
                               {'type' => 'wet', 'name' => 'whiskas'}])
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

      it 'implements #slice' do
        dao.select(:lives).slice(-3).find_one.value.fetch('lives').should eq [7,8,9]
        dao.select(:lives).slice(-3, 3).find_one.value.fetch('lives').should eq [7,8,9]
        dao.select(:lives).slice(6, 5).find_one.value.fetch('lives').should eq [7,8,9]
      end

      it 'implements #elem_match' do
        dao.select(:foods).elem_match(
          dao.where(:type).eq(:wet)
        ).find_one.value.fetch('foods').first.fetch('name').should eq 'whiskas'
      end
    end
  end
end
