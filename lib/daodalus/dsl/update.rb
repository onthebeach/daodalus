module Daodalus
  module DSL
    class Update
      include Clause
      include Updates

      def initialize(dao, query)
        @dao    = dao
        @query  = query
      end

      def set(fields)
        with_clause '$set' => fields
      end

      def unset(fields)
        with_clause '$unset' => fields.reduce({}) { |acc, f| acc.merge(f => 1) }
      end

      def inc(field, amount)
        with_clause '$inc' => { field => amount }
      end

      def dec(field, amount)
        with_clause '$inc' => { field => -amount }
      end

      def rename(field, value)
        with_clause '$rename' => { field => value.to_s }
      end

      def push(field, values)
        if values.length == 1
          with_clause '$push' => { field => values.first }
        else
          push_all field, values
        end
      end

      def push_all(field, values)
        with_clause '$pushAll' => { field => values }
      end

      def add_to_set(field, values)
        if values.length == 1
          with_clause '$addToSet' => { field => values.first }
        else
          add_each_to_set field, values
        end
      end

      def add_each_to_set(field, values)
        with_clause '$addToSet' => { field => { '$each' => values } }
      end

      def pop_first(field)
        with_clause '$pop' => { field => -1 }
      end

      def pop_last(field)
        with_clause '$pop' => { field => 1 }
      end

      def pull(field, values)
        if values.length == 1
          with_clause '$pull' => { field => values.first }
        else
          pull_all field, values
        end
      end

      def pull_all(field, values)
        with_clause '$pullAll' => { field => values }
      end

      private

      def with_clause clause
        Update.new(dao, query.update(clause))
      end

      attr_reader :dao, :query
    end
  end
end
