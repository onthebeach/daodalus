module Daodalus
  module DSL
    module Aggregation
      class Sort
        include Command

        def initialize(dao, fields, query=[])
          @dao = dao
          @fields = fields
          @query = query
        end

        def operator
          '$sort'
        end

        def to_mongo
          {operator => sort_fields}
        end

        private

        def sort_fields
          fields.reduce({}) { |acc, f| acc.merge(sort_field(f)) }
        end

        def sort_field(f)
          f.is_a?(Array) ? {f.first.to_s => direction(f.last)} : {f.to_s => 1}
        end

        def direction(d)
          [false, :desc, :descending, -1].include?(d) ? -1 : 1
        end

        attr_reader :dao, :fields, :query

      end
    end
  end
end
