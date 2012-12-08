require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Match do
        let (:dao) { stub }
        let (:match) { ->(field) { Match.new(dao, field) } }

        it 'builds up a match query' do
          match.(:cats).eq(4).to_query.should eq ([{'$match' => {'cats' => 4}}])
        end
      end
    end
  end
end
