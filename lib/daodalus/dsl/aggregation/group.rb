module Daodalus
  module DSL
    module Aggregation
      class Group
        include Operator

        def initialize(dao, keys, aggregates={}, query=[])
          @dao = dao
          @keys = keys
          @aggregates = aggregates
          @query = query
        end

        def operator
          '$group'
        end

        def sum(field)
          with_aggregate_key('$sum', field)
        end

        def add_to_set(field)
          with_aggregate_key('$addToSet', field)
        end

        def first(field)
          with_aggregate_key('$first', field)
        end

        def last(field)
          with_aggregate_key('$last', field)
        end

        def max(field)
          with_aggregate_key('$max', field)
        end

        def min(field)
          with_aggregate_key('$min', field)
        end

        def avg(field)
          with_aggregate_key('$avg', field)
        end

        def push(field)
          with_aggregate_key('$push', field)
        end

        def to_mongo
          { operator => {'_id' => group_key}.merge(aggregates) }
        end

        private

        attr_reader :dao, :keys, :query, :aggregates

        def with_aggregate_key(op, field)
          Group.new(dao, keys, aggregates.merge(build_aggregate_key(op, field)), query)
        end

        def build_aggregate_key(op, field)
          if field.is_a?(Hash)
            field.reduce({}) do |acc, (k, v)|
              acc.merge(k.to_s => { op => field_as_operator(v) })
            end
          else
            {field.to_s => { op => field_as_operator(field) }}
          end
        end

        def group_key
          if keys.length == 1 && keys.first.is_a?(Hash)
            Hash[keys.first.map{|k,v| [k.to_s, field_as_operator(v)]}]
          elsif keys.length == 1
            field_as_operator(keys.first)
          else
            Hash[keys.map{|k| [k.to_s, field_as_operator(k)]}]
          end
        end

      end
    end
  end
end
