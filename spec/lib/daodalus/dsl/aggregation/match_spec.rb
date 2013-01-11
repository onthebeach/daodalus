require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Match do
        let (:dao) { stub }
        let (:match) { ->(field) { Match.new(dao, field) } }

        it 'builds up a match query' do
          match.(:cats).eq(4).and(:fish).lt(2).to_query.should eq ([{'$match' => {'cats' => 4, 'fish' => {'$lt' => 2}}}])
        end

        it 'combines consecutive matches' do
          match.(:cats).eq(4).match(:fish).lt(2).to_query.should eq ([{'$match' => {'cats' => 4, 'fish' => {'$lt' => 2}}}])
        end
      end
    end
  end
end
