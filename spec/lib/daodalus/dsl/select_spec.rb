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

      it 'allows the selection of fields to be returned' do
        dao.select(:name, :paws).find_one.value.keys.should eq ['name', 'paws']
      end

      it 'allows the chaining of selects' do
        dao.select(:name).and(:paws).find_one.value.keys.should eq ['name', 'paws']
      end

    end
  end
end
