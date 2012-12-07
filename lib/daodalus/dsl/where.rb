module Daodalus
  module DSL

    class Where

      attr_reader :where_clause, :select_clause

      def initialize(dao, field=nil, where_clause={}, select_clause={})
        @dao           = dao
        @field         = field.to_s
        @where_clause  = where_clause
        @select_clause = select_clause
      end

      def ne(value)
        with_condition('$ne', value)
      end
      alias_method :not_equal, :ne

      def lt(value)
        with_condition('$lt', value)
      end
      alias_method :less_than, :lt

      def lte(value)
        with_condition('$lte', value)
      end
      alias_method :less_than_or_equal, :lte

      def gt(value)
        with_condition('$gt', value)
      end
      alias_method :greater_than, :gt

      def gte(value)
        with_condition('$gte', value)
      end
      alias_method :greater_than_or_equal, :gte

      def in(*values)
        with_condition('$in', values)
      end

      def nin(*values)
        with_condition('$nin', values)
      end
      alias_method :not_in, :nin

      def all(*values)
        with_condition('$all', values)
      end

      def size(value)
        with_condition('$size', value)
      end

      def exists(value=true)
        with_condition('$exists', value)
      end

      def does_not_exist
        exists(false)
      end

      def mod(divisor, remainder)
        with_condition('$mod', [divisor, remainder])
      end
      alias_method :modulus, :mod

      def and(*args)
        if field_arg?(args)
          Where.new(dao, args.first, where_clause, select_clause)
        elsif args.all?{ |a| a.is_a?(Where) }
          chain('$and' => args.map(&:where_clause))
        else
          raise ArgumentError, "Not an accepted argument of #and #{args.inspect}"
        end
      end

      def not(clause)
        chain('$not' => clause.where_clause)
      end

      def nor(*clauses)
        chain('$nor' => clauses.map(&:where_clause))
      end

      def or(*clauses)
        chain('$or' => clauses.map(&:where_clause))
      end

      def elem_match(clause)
        with_condition('$elemMatch', clause.where_clause)
      end
      alias_method :element_match, :elem_match

      def eq(value)
        chain(where_clause.merge(field => value))
      end
      alias_method :equals, :eq

      private

      attr_reader :dao, :field

      def field_arg?(args)
        args.length == 1 &&
          (args.first.is_a?(String) || args.first.is_a?(Symbol))
      end

      def with_condition(op, value)
        chain(where_clause.merge(field => { op => value}))
      end

      def chain(where_clause)
        Where.new(dao, field, where_clause, select_clause)
      end
    end
  end
end

