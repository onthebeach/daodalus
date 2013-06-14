module Daodalus
  module DSL
    module Queries

      def find
        dao.find(query.wheres, fields: query.selects)
      end

      def find_one
        dao.find_one(query.wheres, fields: query.selects)
      end

    end
  end
end
