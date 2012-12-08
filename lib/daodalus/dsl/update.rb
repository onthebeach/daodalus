module Daodalus
  module DSL
    class Update
      attr_reader :criteria, :update_clauses

      def initialize(dao, criteria={}, update_clauses={})
        @dao = dao
        @criteria = criteria
        @update_clauses = update_clauses
      end

      def set(field, value)
        with_update('$set', {field.to_s => value})
      end

      def unset(field)
        with_update('$unset', {field.to_s => ''})
      end

      def inc(field, amount=1)
        with_update('$inc', {field.to_s => amount})
      end

      def rename(field, value)
        with_update('$rename', {field.to_s => value.to_s})
      end

      def push(field, *values)
        if values.length == 1
          with_update('$push', {field.to_s => values.first})
        else
          push_all(field, *values)
        end
      end

      def push_all(field, *values)
        with_update('$pushAll', {field.to_s => values})
      end

      def add_to_set(field, *values)
        if values.length == 1
          with_update('$addToSet', {field.to_s => values.first})
        else
          with_update('$addToSet', {field.to_s => { '$each' => values }})
        end
      end

      def pop_first(field)
        with_update('$pop', {field.to_s => -1})
      end

      def pop_last(field)
        with_update('$pop', {field.to_s => 1})
      end
      alias_method :pop, :pop_last

      def pull(field, *values)
        if values.length == 1
          with_update('$pull', {field.to_s => values.first})
        else
          pull_all(field, *values)
        end
      end

      def pull_all(field, *values)
        with_update('$pullAll', {field.to_s => values})
      end

      private

      attr_reader :dao

      def with_update(op, value)
        Update.new(dao, criteria, build_update(op, value))
      end

      def build_update(op, value)
        update_clauses.merge(op => value) { |k,a,b| a.merge(b) }
      end
    end
  end
end

