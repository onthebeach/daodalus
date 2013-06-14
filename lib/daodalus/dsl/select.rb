module Daodalus
  module DSL
    class Select
      include Queries

      def initialize(dao, query, fields)
        @dao   = dao
        @query = query
        @fields = fields
      end

      private

      def query
        @query.select(fields.reduce({}) { |acc, f| acc.merge(f.to_s => 1) })
      end

      attr_reader :dao, :fields
    end
  end
end
