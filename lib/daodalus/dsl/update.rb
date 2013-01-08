module Daodalus
  module DSL
    class Update
      include Updates
      attr_reader :criteria, :select_clause, :update_clause

      def initialize(dao, criteria={}, select_clause={}, update_clause={})
        @dao = dao
        @criteria = criteria
        @select_clause = select_clause
        @update_clause = update_clause
      end

      def set(field, value)
        with_update('$set', field, value)
      end

      def unset(field)
        with_update('$unset', field, '')
      end

      def inc(field, amount=1)
        with_update('$inc', field, amount)
      end

      def rename(field, value)
        with_update('$rename', field, value.to_s)
      end

      def push(field, *values)
        if values.length == 1
          with_update('$push', field, values.first)
        else
          push_all(field, values)
        end
      end

      def push_all(field, values)
        with_update('$pushAll', field, values)
      end

      def add_to_set(field, *values)
        if values.length == 1
          with_update('$addToSet', field, values.first)
        else
          add_each_to_set(field, values)
        end
      end

      def add_each_to_set(field, values)
        with_update('$addToSet', field, { '$each' => values })
      end

      def pop_first(field)
        with_update('$pop', field, -1)
      end

      def pop_last(field)
        with_update('$pop', field, 1)
      end
      alias_method :pop, :pop_last

      def pull(field, *values)
        if values.length == 1
          with_update('$pull', field, values.first)
        else
          pull_all(field, values)
        end
      end

      def pull_all(field, values)
        with_update('$pullAll', field, values)
      end

      def where(field)
        Where.new(dao, field, criteria, select_clause, update_clause)
      end

      private

      attr_reader :dao

      def with_update(op, field, value)
        Update.new(dao, criteria, select_clause, build_update(op, field.to_s => value))
      end

      def build_update(op, value)
        update_clause.merge(op => value) { |k,a,b| a.merge(b) }
      end
    end
  end
end

