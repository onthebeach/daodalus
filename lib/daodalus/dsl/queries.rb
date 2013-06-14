module Daodalus
  module DSL
    module Queries

      def find
        dao.find(query.wheres)
      end
    end
  end
end
