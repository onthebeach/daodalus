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
