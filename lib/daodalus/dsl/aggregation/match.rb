module Daodalus
  module DSL
    module Aggregation
      class Match
        include Clause
        include Operator

        def initialize(dao, field, criteria={}, query=[])
          @dao = dao
          @field = field.to_s
          @criteria = criteria
          @query = query
        end

        def operator
          '$match'
        end

        def to_mongo
          { operator => criteria }
        end

        private

        attr_reader :dao, :field, :criteria, :query

        def chain(field)
          Match.new(dao, field, criteria, query)
        end

        def add_clause(criteria)
          Match.new(dao, field, criteria, query)
        end

      end
    end
  end
end
