module Daodalus
  module DSL
    class Where
      include Clause
      include Queries
      include Updates

      attr_reader :criteria, :select_clause, :update_clause

      def initialize(dao, field=nil, criteria={}, select_clause={}, update_clause={})
        @dao           = dao
        @field         = field.to_s
        @criteria      = criteria
        @select_clause = select_clause
        @update_clause = update_clause
      end

      def count(options = {})
        dao.count(criteria, options)
      end

      def remove(options = {})
        dao.remove(criteria, options)
      end

      def transform(&block)
        Transform.new(self, block)
      end

      private

      attr_reader :dao, :field

      def chain(field)
        Where.new(dao, field, criteria, select_clause, update_clause)
      end

      def add_clause(criteria)
        Where.new(dao, field, criteria, select_clause, update_clause)
      end

    end
  end
end

