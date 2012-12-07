module Daodalus
  module DSL
    class Match
      include Clause
      attr_reader :match_clause, :query

      def initialize(dao, field, match_clause={}, query=[])
        @dao = dao
        @field = field
        @match_clause = match_clause
        @query = query
      end

      def operator
        '$match'
      end

      private

      attr_reader :dao, :field

      def chain(field)
        Match.new(dao, field, match_clause, query)
      end

      def add_clause(match_clause)
        Where.new(dao, field, match_clause, query)
      end

    end
  end
end
