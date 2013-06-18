module Daodalus
  module DSL
    module Aggregation
      class Sort
        include Aggregations

        def initialize(dao, aggregations, keys)
          @dao          = dao
          @aggregations = aggregations
          @keys         = keys
        end

        def to_aggregation
          { '$sort' => keys }
        end

        private

        def keys
          @keys.reduce({}) do |acc, (k,v)|
            acc.merge(k => ([-1, :desc, 'desc'].include?(v) ? -1 : 1))
          end
        end

        attr_reader :dao, :aggregations
      end
    end
  end
end
