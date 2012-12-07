module Daodalus
  module DSL
    module Aggregation
      module Command

        def match(field=nil)
          Match.new(dao, field, to_query)
        end

        private

        def to_query
          criteria.empty? ? query : query + { operator => criteria }
        end

        def operator
          raise NotImplementedError, "Including classes must implement this"
        end

        def dao
          raise NotImplementedError, "Including classes must implement this"
        end

        def query
          raise NotImplementedError, "Including classes must implement this"
        end

        def criteria
          raise NotImplementedError, "Including classes must implement this"
        end

      end
    end
  end
end
