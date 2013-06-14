module Daodalus
  module DSL
    class Select
      include Queries

      def initialize(dao, query, fields)
        @dao   = dao
        @query = query
        @field = field
      end

      private

      attr_reader :dao, :query, :field
    end
  end
end
