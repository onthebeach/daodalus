module Daodalus
  module DSL

    module Clause

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
          chain(args.first)
        elsif args.all?{ |a| a.is_a?(Clause) }
          add_clause('$and' => args.map(&:criteria))
        else
          raise ArgumentError, "Not an accepted argument of #and #{args.inspect}"
        end
      end

      def not(clause)
        add_clause('$not' => clause.criteria)
      end

      def nor(*clauses)
        add_clause('$nor' => clauses.map(&:criteria))
      end

      def or(*clauses)
        add_clause('$or' => clauses.map(&:criteria))
      end

      def elem_match(clause)
        with_condition('$elemMatch', clause.criteria)
      end
      alias_method :element_match, :elem_match

      def eq(value)
        add_clause(criteria.merge(field => value))
      end
      alias_method :equals, :eq

      private

      attr_reader :dao, :field

      def field_arg?(args)
        args.length == 1 &&
          (args.first.is_a?(String) || args.first.is_a?(Symbol))
      end

      def with_condition(op, value)
        add_clause(build_clause(op,value))
      end

      def build_clause(op, value)
        criteria.merge(field => { op => value}) { |k,a,b| a.merge(b) }
      end

      def chain(field)
        raise NotImplementedError, "Including classe must provide a chain method"
      end

      def add_clause(criteria)
        raise NotImplementedError, "Including classe must provide an add clause method"
      end
    end
  end
end

