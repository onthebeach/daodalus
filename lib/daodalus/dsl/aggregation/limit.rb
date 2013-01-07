module Daodalus
  module DSL
    module Aggregation
      class Limit
        include Operator

        def initialize(dao, total, query=[])
          @dao = dao
          @total = total
          @query = query
        end

        def operator
          '$limit'
        end

        def to_mongo
          {operator => total}
        end

        private

        attr_reader :dao, :total, :query

      end
    end
  end
end
