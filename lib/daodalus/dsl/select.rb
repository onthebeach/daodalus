module Daodalus
  module DSL
    class Select
      include Queries

      attr_reader :dao

      def initialize(dao, fields, criteria={}, select_clause={'_id' => 0})
        @dao = dao
        @fields = fields
        @criteria = criteria
        @select_clause = select_clause
      end

      def select_clause
        fields.reduce(@select_clause){ |acc, f| acc.merge(f.to_s => 1) }
      end

      def and(*fields)
        Select.new(dao, fields, criteria, select_clause)
      end

      def slice(number)
        Select.new(dao, [], criteria, slice_clause(number))
      end

      def where(field)
        Where.new(dao, field, criteria, select_clause)
      end

      def transform(f=nil, &block)
        Transform.new(self, f.nil? ? block : dao.method(f))
      end

      private

      def slice_clause(number)
        fields.reduce(@select_clause){ |acc, f| acc.merge(f.to_s => {'$slice' => number}) }
      end
      attr_reader :fields, :criteria

    end
  end
end
