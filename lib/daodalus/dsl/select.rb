module Daodalus
  module DSL
    class Select
      include Queries

      def initialize(dao, query, fields)
        @dao   = dao
        @query = query
        @fields = fields
      end

      def to_query
        query.wheres
      end

      def to_projection
        query.selects
      end

      def to_update
        query.updates
      end

      def select *fields
        Select.new(dao, query, fields)
      end
      alias_method :and, :select

      def by_position
        raise InvalidQueryError, "Too many fields for positional operator: #{fields.inspect}" if fields.size > 1
        Select.new(dao, @query, ["#{fields.first}.$"])
      end

      def where *fields
        Where.new(dao, query, fields)
      end

      private

      def query
        @query.select(fields.reduce({}) { |acc, f| acc.merge(f.to_s => 1) })
      end

      attr_reader :dao, :fields
    end
  end
end
