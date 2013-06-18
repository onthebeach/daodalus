require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Limit do

        let (:dao) { DAO.new(:animalhouse, :cats) }

        before do
          dao.insert('name'  => 'Terry')
          dao.insert('name'  => 'Jemima')
        end

        it 'allows an aggregation query to be limited' do
          dao.limit(1).project(:name).aggregate.should eq ['name' => 'Terry']
        end

      end
    end
  end
end
