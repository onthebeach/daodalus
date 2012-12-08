require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Limit do
        let (:dao) { stub }
        let (:limit) { ->(number) { Limit.new(dao, 30) } }

        it 'can take a number to limit by' do
          limit.(30).to_query.should eq [{'$limit' => 30}]
        end
      end
    end
  end
end
