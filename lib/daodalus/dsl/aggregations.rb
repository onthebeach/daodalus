module Daodalus
  module DSL
    module Aggregations

      def aggregate
        dao.aggregate(pipeline)
      end

      def match(field=nil)
        Aggregation::Match.new(dao, pipeline, Query.new, field)
      end

      def group(keys)
        Aggregation::Group.new(dao, pipeline, keys, {})
      end
      alias_method :group_by, :group

      def project(*keys)
        Aggregation::Project.new(dao, pipeline, keys)
      end

      def pipeline
        aggregations + [to_aggregation]
      end

    end
  end
end
