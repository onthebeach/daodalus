module Daodalus
  module DSL
    class Where
      include Clause
      attr_reader :where_clause, :select_clause

      def initialize(dao, field=nil, where_clause={}, select_clause={})
        @dao           = dao
        @field         = field.to_s
        @where_clause  = where_clause
        @select_clause = select_clause
      end

      private

      attr_reader :dao, :field

      def chain(field)
        Where.new(dao, field, where_clause, select_clause)
      end

      def add_clause(where_clause)
        Where.new(dao, field, where_clause, select_clause)
      end

    end
  end
end

