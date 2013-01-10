module Daodalus
  module DSL
    class Select
      include Queries
      include Chainable

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

      def elem_match(field, value)
        Select.new(dao, [], criteria, elem_match_clause(field, value))
      end

      def where(field)
        Where.new(dao, field, criteria, select_clause)
      end

      private

      def slice_clause(number)
        fields.reduce(@select_clause){ |acc, f| acc.merge(f.to_s => {'$slice' => number}) }
      end

      def elem_match_clause(field, value)
        fields.reduce(@select_clause) do |acc, f|
          acc.merge(f.to_s => {'$elemMatch' => { field.to_s => value }})
        end
      end

      attr_reader :fields, :criteria

    end
  end
end
