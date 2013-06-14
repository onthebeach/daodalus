module Daodalus
  module DSL
    class Select
      include Clause
      include Queries

      def initialize(dao, query, fields)
        @dao   = dao
        @query = query
        @fields = fields
      end

      def select *fields
        Select.new(dao, query.select(fields.reduce({}) { |acc, f| acc.merge(f.to_s => 1) }), fields)
      end
      alias_method :and, :select

      def by_position
        raise InvalidQueryError, "Too many fields for positional operator: #{fields.inspect}" if fields.size > 1
        Select.new(dao, @query.select("#{fields.first}.$" => 1), [])
      end
      alias_method :positional, :by_position

      def slice skip=false, limit
        raise InvalidQueryError, "Too many fields for slice operator: #{fields.inspect}" if fields.size > 1
        if skip
          Select.new(dao, @query.select(fields.first.to_s => { '$slice' => [skip, limit]}), [])
        else
          Select.new(dao, @query.select(fields.first.to_s => { '$slice' => limit}), [])
        end
      end

      def elem_match clause
        Select.new(dao, @query.select(fields.first.to_s => { '$elemMatch' => clause.to_query}), [])
      end

      private

      def query
        @query.select(fields.reduce({}) { |acc, f| acc.merge(f.to_s => 1) })
      end

      attr_reader :dao, :fields
    end
  end
end
