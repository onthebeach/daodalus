module Daodalus
  module DSL
    module Aggregation
      class Match
        include Clause
        include Command
        attr_reader :query, :criteria

        def initialize(dao, field, query=[], criteria={})
          @dao = dao
          @field = field.to_s
          @query = query
          @criteria = criteria
        end

        def operator
          '$match'
        end

        private

        attr_reader :dao, :field

        def chain(field)
          Match.new(dao, field, query, criteria)
        end

        def add_clause(criteria)
          Match.new(dao, field, query, criteria)
        end

      end
    end
  end
end
