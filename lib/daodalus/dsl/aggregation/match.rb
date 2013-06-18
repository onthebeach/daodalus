module Daodalus
  module DSL
    module Aggregation
      class Match
        include Matchers
        include Aggregations

        def initialize(dao, aggregations, query, field)
          @dao          = dao
          @aggregations = aggregations
          @query        = query
          @field        = field
        end

        alias_method :and, :match

        def to_aggregation
          { '$match' => query.wheres }
        end

        private

        def add_clause clause
          Match.new(dao, aggregations, query.where(field.to_s => clause), field)
        end

        def add_logical_clause clause
          Match.new(dao, aggregations, query.where(clause), field)
        end

        attr_reader :dao, :aggregations, :query, :field
      end
    end
  end
end
