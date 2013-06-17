module Daodalus
  module DSL
    module Matchers

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

      def not
        define_singleton_method :add_clause do |clause|
          add_logical_clause field.to_s => { '$not' => clause }
        end
        define_singleton_method :eq do |value|
          add_logical_clause field.to_s => { '$ne' => value}
        end
        self
      end

      def any *clauses
        add_logical_clause '$or' => clauses.map(&:to_query)
      end
      alias_method :or, :any

      def none *clauses
        add_logical_clause '$nor' => clauses.map(&:to_query)
      end
      alias_method :nor, :none

      def elem_match clause
        add_clause '$elemMatch' => clause.to_query
      end

    end
  end
end

