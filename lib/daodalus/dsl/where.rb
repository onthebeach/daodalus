module Daodalus
  module DSL
    class Where
      include Queries

      def initialize(dao, query, field)
        @dao   = dao
        @query = query
        @field = field
      end

      def eq value
        add_clause value
      end
      alias_method :equals, :eq

      def ne value
        add_clause '$ne' => value
      end
      alias_method :not_equal, :ne

      def lt value
        add_clause '$lt' => value
      end
      alias_method :less_than, :lt

      def gt value
        add_clause '$gt' => value
      end
      alias_method :greater_than, :gt

      def lte value
        add_clause '$lte' => value
      end
      alias_method :less_than_or_equal, :lte

      def gte value
        add_clause '$gte' => value
      end
      alias_method :greater_than_or_equal, :gte

      def in *values
        add_clause '$in' => values
      end

      def nin *values
        add_clause '$nin' => values
      end
      alias_method :not_in, :nin

      def all *values
        add_clause '$all' => values
      end

      def size value
        add_clause '$size' => value
      end

      def exists value=true
        add_clause '$exists' => value
      end

      def does_not_exist *values
        exists false
      end

      def where field
        Where.new(dao, query, field)
      end
      alias_method :and, :where

      def not
        define_singleton_method :add_clause do |clause|
          Where.new(dao, query.where(field.to_s => { '$not' => clause}), field)
        end
        define_singleton_method :eq do |value|
          Where.new(dao, query.where(field.to_s => { '$ne' => value}), field)
        end
        self
      end

      private

      def add_clause clause
        Where.new(dao, query.where(field.to_s => clause), field)
      end

      attr_reader :dao, :query, :field
    end
  end
end
