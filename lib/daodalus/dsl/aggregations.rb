module Daodalus
  module DSL
    module Aggregations

      def aggregate
        dao.aggregate(pipeline)
      end

      def match(field=nil)
        Aggregation::Match.new(dao, pipeline, Query.new, field)
      end

      def pipeline
        aggregations + [to_aggregation]
      end

    end
  end
end
