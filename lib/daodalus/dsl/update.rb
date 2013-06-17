module Daodalus
  module DSL
    class Update
      include Clause
      include Updates

      def initialize(dao, query)
        @dao    = dao
        @query  = query
      end

      def set(fields)
        with_clause '$set' => fields
      end

      private

      def with_clause clause
        Update.new(dao, query.update(clause))
      end

      attr_reader :dao, :query
    end
  end
end
