require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Match do

        let (:dao) { DAO.new(:animalhouse, :cats) }

        before do
          dao.insert('name'  => 'Terry',
                     'paws'  => 3,
                     'likes' => ['tuna', 'catnip'],
                     'foods' => [{'type' => 'dry', 'name' => 'go cat'},
                                 {'type' => 'wet', 'name' => 'whiskas'}])
        end

        it 'allows queries to be made on the pipeline' do
          dao.match(:name).eq('Terry').and(paws: 3).aggregate.should have(1).item
          dao.match(:name).eq('Terry').aggregate.first.fetch('paws').should eq 3
        end

        it 'also works with the logical query operators' do
          dao.match.any(
            dao.where(:name).eq('Terrence'),
            dao.where(:name).eq('Terry')
          ).aggregate.should have(1).item
        end
      end
    end
  end
end
