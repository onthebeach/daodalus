module Daodalus
  module DSL
    class Where
      include Clause
      attr_reader :criteria, :select_clause, :update_clause

      def initialize(dao, field=nil, criteria={}, select_clause={}, update_clause={})
        @dao           = dao
        @field         = field.to_s
        @criteria      = criteria
        @select_clause = select_clause
        @update_clause = update_clause
      end

      def update
        dao.update(criteria, update_clause)
      end

      def find
        dao.find(criteria, select_clause)
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

