module Daodalus
  module DSL
    class Select
      include Queries

      def initialize(dao, fields, criteria={}, select_clause={'_id' => 0})
        @dao = dao
        @fields = fields
        @criteria = criteria
        @select_clause = select_clause
      end

      def select_clause
        fields.reduce(@select_clause){ |acc, f| acc.merge(f.to_s => 1) }
      end

      def with(*fields)
        Select.new(dao, fields, criteria, select_clause)
      end

      def slice(number)
        Select.new(dao, [], criteria, slice_clause(number))
      end

      def where(field)
        Where.new(dao, field, criteria, select_clause)
      end

      def transform(&block)
        Transform.new(self, block)
      end

      private

      def slice_clause(number)
        fields.reduce(@select_clause){ |acc, f| acc.merge(f.to_s => {'$slice' => number}) }
      end
      attr_reader :dao, :fields, :criteria

    end
  end
end
