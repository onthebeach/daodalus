require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Skip do
        let (:dao) { stub }
        let (:skip) { ->(number) { Skip.new(dao, number) } }

        it 'can take a number to limit by' do
          skip.(30).to_query.should eq [{'$skip' => 30}]
        end
      end
    end
  end
end
