module Daodalus
  module DSL
    module Clause

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
