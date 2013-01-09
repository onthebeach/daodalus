module Daodalus
  module DSL
    class Where
      include Clause
      include Queries
      include Updates
      include With

      attr_reader :dao, :criteria, :select_clause, :update_clause

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

      def transform(f=nil, &block)
        Transform.new(self, f.nil? ? block : dao.method(f))
      end

      private

      attr_reader :field

      def chain(field)
        Where.new(dao, field, criteria, select_clause, update_clause)
      end

      def add_clause(criteria)
        Where.new(dao, field, criteria, select_clause, update_clause)
      end

    end
  end
end

