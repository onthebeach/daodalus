module Daodalus
  module DSL
    module Aggregation
      class Group
        include Matchers
        include Aggregations

        def initialize(dao, aggregations, id, values)
          @dao          = dao
          @aggregations = aggregations
          @id           = id
          @values       = values
        end

        def to_aggregation
          { '$group' => values.merge('_id' => id) }
        end

        def sum(field)
          aliased '$sum' => field
        end
        alias_method :total, :sum

        def add_to_set(field)
          aliased '$addToSet' => field
        end
        alias_method :distinct, :add_to_set

        def push(field)
          aliased '$push' => field
        end
        alias_method :collect, :push

        def first(field)
          aliased '$first' => field
        end

        def last(field)
          aliased '$last' => field
        end

        def max(field)
          aliased '$max' => field
        end

        def min(field)
          aliased '$min' => field
        end

        def avg(field)
          aliased '$avg' => field
        end
        alias_method :average, :avg

        private

        def id
          case @id
          when Symbol then @id.to_s
          when Hash   then @id.reduce({}) {|acc, (a,b)| acc.merge(a.to_s => b.to_s) }
          else @id
          end
        end

        def aliased clause
          Alias.new do |aka|
            Group.new(dao, aggregations, id, values.merge(aka => clause))
          end
        end

        attr_reader :dao, :aggregations, :values

        class Alias
          def initialize(&block)
            @block = block
          end

          def as(aka)
            block.call(aka)
          end

          private

          attr_reader :block
        end
      end
    end
  end
end
