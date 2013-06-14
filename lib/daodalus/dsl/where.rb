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

      def where field
        Where.new(dao, query, field)
      end
      alias_method :and, :where

      private

      def add_clause clause
        Where.new(dao, query.where(field.to_s => clause), field)
      end

      attr_reader :dao, :query, :field
    end
  end
end
