module Daodalus
  module DSL
    module Clause

      def where field=nil
        if field.is_a? Hash
          Where.new(dao, query.where(field), nil)
        else
          Where.new(dao, query, field)
        end
      end

      def select *fields
        Select.new(dao, query, fields)
      end

      def set(fields)
        Update.new(dao, query).set(fields)
      end

      def unset(*fields)
        Update.new(dao, query).unset(fields)
      end

      def inc(field, amount=1)
        Update.new(dao, query).inc(field, amount)
      end

      def dec(field, amount=1)
        Update.new(dao, query).dec(field, amount)
      end

      def rename(field, value)
        Update.new(dao, query).rename(field, value)
      end

      def push(field, *values)
        Update.new(dao, query).push(field, values)
      end

      def push_all(field, values)
        Update.new(dao, query).push_all(field, values)
      end

      def add_to_set(field, *values)
        Update.new(dao, query).add_to_set(field, values)
      end

      def add_each_to_set(field, values)
        Update.new(dao, query).add_each_to_set(field, values)
      end

      def pop_first(field)
        Update.new(dao, query).pop_first(field)
      end

      def pop_last(field)
        Update.new(dao, query).pop_last(field)
      end

      def pull(field, *values)
        Update.new(dao, query).pull(field, values)
      end

      def pull_all(field, values)
        Update.new(dao, query).pull_all(field, values)
      end

      def to_query
        query.wheres
      end

      def to_projection
        query.selects
      end

      def to_update
        query.updates
      end

    end
  end
end
