module Daodalus
  module DSL
    module Queries

      def find
        dao.find(query.wheres)
      end

      def find_one
        dao.find_one(query.wheres)
      end

    end
  end
end
