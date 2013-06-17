module Daodalus
  module DSL
    module Aggregation
      class Project
        include Matchers
        include Aggregations

        def initialize(dao, aggregations, keys)
          @dao          = dao
          @aggregations = aggregations
          @keys         = keys
        end

        def to_aggregation
          { '$project' => { '_id' => 0 }.merge(keys) }
        end

        private

        def keys
          if @keys.size == 1 && @keys.first.is_a?(Hash)
            @keys.first
          else
            @keys.reduce({}){ |acc, k| acc.merge(k.to_s => 1) }
          end
        end

        attr_reader :dao, :aggregations
      end
    end
  end
end
