require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Project do

        let (:dao) { DAO.new(:animalhouse, :cats) }

        before do
          dao.insert('name'  => 'Terry',
                     'paws'  => 3,
                     'likes' => ['tuna', 'catnip'],
                     'foods' => [{'type' => 'dry', 'name' => 'go cat'},
                                 {'type' => 'wet', 'name' => 'whiskas'}])

        end

        it 'can project a list of fields' do
          dao.project(:name, :paws).aggregate.should eq [
            {'name' => 'Terry', 'paws' => 3}
          ]
        end

        it 'can rename fields' do
          dao.project(feet: '$paws').aggregate.should eq ['feet' => 3]
        end


      end
    end
  end
end
