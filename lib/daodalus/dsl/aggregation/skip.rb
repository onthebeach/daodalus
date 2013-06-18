module Daodalus
  module DSL
    module Aggregation
      class Skip
        include Aggregations

        def initialize(dao, aggregations, skip)
          @dao          = dao
          @aggregations = aggregations
          @skip         = skip
        end

        def to_aggregation
          { '$skip' => skip }
        end

        private

        attr_reader :dao, :aggregations, :skip
      end
    end
  end
end
