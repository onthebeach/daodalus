module Daodalus
  module DSL
    module Aggregation
      class Skip
        include Command

        def initialize(dao, total, query=[])
          @dao = dao
          @total = total
          @query = query
        end

        def operator
          '$skip'
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
