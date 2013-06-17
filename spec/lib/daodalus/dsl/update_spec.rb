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

      it 'implements #set' do
        dao.set(name: 'Terrence', paws: 2).update
        dao.find_one.value.fetch('paws').should eq 2
        dao.find_one.value.fetch('name').should eq 'Terrence'
      end

    end
  end
end
