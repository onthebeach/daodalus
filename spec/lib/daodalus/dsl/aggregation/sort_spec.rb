require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Sort do
        let (:dao) { stub }
        let (:sort) { ->(*fields) { Sort.new(dao, fields) } }

        it 'can take a number to limit by' do
          sort.(:cats, [:dogs, :desc]).to_query.
            should eq [{'$sort' => {'cats' => 1, 'dogs' => -1}}]
        end
      end
    end
  end
end
