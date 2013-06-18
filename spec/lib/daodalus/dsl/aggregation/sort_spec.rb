require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Sort do

        let (:dao) { DAO.new(:animalhouse, :cats) }

        before do
          dao.insert('name'  => 'Terry', paws: 2)
          dao.insert('name'  => 'Jemima', paws: 4)
        end

        it 'allows an aggregation query to be sorted' do
          dao.sort(name: 1).project(:name).aggregate.should eq [
            {"name"=>"Jemima"},
            {"name"=>"Terry"}
          ]
          dao.sort(name: -1).project(:name).aggregate.should eq [
            {"name"=>"Terry"},
            {"name"=>"Jemima"}
          ]
        end

        it 'accepts symbols for sort order' do
          dao.sort(paws: :desc).project(:name).aggregate.should eq [
            {"name"=>"Jemima"},
            {"name"=>"Terry"}
          ]
        end

      end
    end
  end
end
