module Daodalus
  module DSL
    class Where
      include Queries

      def initialize(dao, query, field)
        @dao   = dao
        @query = query
        @field = field
      end

      def eq value
        Where.new(dao, query.where(field.to_s => value), field)
      end

      private

      attr_reader :dao, :query, :field
    end
  end
end
