require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Unwind do

        let (:dao) { DAO.new(:animalhouse, :cats) }

        before do
          dao.insert('name'  => 'Terry', 'likes' => ['tuna', 'cakes'])
        end

        it 'allows an aggregation query to be unwound' do
          dao.unwind(:likes).project(:name, :likes).aggregate.should eq [
            {"name"=>"Terry", "likes"=>"tuna"},
            {"name"=>"Terry", "likes"=>"cakes"}
          ]
        end

      end
    end
  end
end
