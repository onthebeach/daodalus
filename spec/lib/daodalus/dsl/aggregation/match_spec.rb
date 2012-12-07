require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Match do
        let (:dao) { stub }
        let (:query) { Match.new(dao, nil) }

        it 'builds up a match query' do
          query.match(:cats).eq(4).criteria.should eq ({'cats' => 4})
        end
      end
    end
  end
end
