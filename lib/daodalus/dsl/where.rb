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
