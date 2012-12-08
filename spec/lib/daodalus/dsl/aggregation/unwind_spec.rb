require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Unwind do
        let (:dao) { stub }
        let (:unwind) { ->(field) { Unwind.new(dao, field) } }

        it 'can take a field to unwind' do
          unwind.(:cats).to_query.should eq [{'$unwind' => '$cats'}]
        end
      end
    end
  end
end
