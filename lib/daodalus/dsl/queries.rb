module Daodalus
  module DSL
    module Queries

      def find(options = {})
        dao.find(query.wheres, options.merge(fields: query.selects))
      end

      def find_one(options = {})
        dao.find_one(query.wheres, options.merge(fields: query.selects))
      end

    end
  end
end
