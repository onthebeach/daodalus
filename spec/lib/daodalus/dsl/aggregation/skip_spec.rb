require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Skip do

        let (:dao) { DAO.new(:animalhouse, :cats) }

        before do
          dao.insert('name'  => 'Terry')
          dao.insert('name'  => 'Jemima')
        end

        it 'allows an aggregation query to skip some records' do
          dao.skip(1).project(:name).aggregate.should eq ['name' => 'Jemima']
        end

      end
    end
  end
end
