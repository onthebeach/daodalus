module Daodalus
  module DSL
    module Updates

      def update(options = {})
        dao.update(query.wheres, query.updates, options)
      end

      def upsert(options = {})
        update(options.merge(upsert: true))
      end

      def find_and_modify(options = {})
        dao.find_and_modify(options.merge(query: query.wheres, update: query.updates))
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

    end
  end
end
