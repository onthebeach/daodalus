module Daodalus
  module DSL
    module Aggregation
      class Limit
        include Aggregations

        def initialize(dao, aggregations, limit)
          @dao          = dao
          @aggregations = aggregations
          @limit        = limit
        end

        def to_aggregation
          { '$limit' => limit }
        end

        private

        attr_reader :dao, :aggregations, :limit
      end
    end
  end
end
