module Daodalus
  module DSL
    module Clause

      def where field=nil
        Where.new(dao, query, field)
      end

      def select *fields
        Select.new(dao, query, fields)
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

    end
  end
end
