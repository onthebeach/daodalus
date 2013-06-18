module Daodalus
  module DSL
    class Where
      include Clause
      include Updates
      include Queries
      include Matchers

      def initialize(dao, query, field)
        @dao    = dao
        @query  = query
        @field = field
      end

      alias_method :and, :where

      private

      def add_clause clause
        Where.new(dao, query.where(field.to_s => clause), field)
      end

      def add_logical_clause clause
        Where.new(dao, query.where(clause), field)
      end

      attr_reader :dao, :query, :field
    end
  end
end
