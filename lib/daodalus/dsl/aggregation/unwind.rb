module Daodalus
  module DSL
    module Aggregation
      class Unwind
        include Aggregations

        def initialize(dao, aggregations, field)
          @dao          = dao
          @aggregations = aggregations
          @field        = field
        end

        def to_aggregation
          { '$unwind' => "$#{field}" }
        end

        private

        attr_reader :dao, :aggregations, :field
      end
    end
  end
end
