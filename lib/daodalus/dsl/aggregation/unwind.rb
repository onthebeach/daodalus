module Daodalus
  module DSL
    module Aggregation
      class Unwind
        include Operator

        def initialize(dao, field, query=[])
          @dao = dao
          @field = field
          @query = query
        end

        def operator
          '$unwind'
        end

        def to_mongo
          {operator => field_as_operator(field)}
        end

        private

        attr_reader :field, :query

      end
    end
  end
end
