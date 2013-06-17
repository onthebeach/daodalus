module Daodalus
  module DSL
    module Updates

      def update(options = {})
        dao.update(query.wheres, query.updates, options)
      end

      def upsert(options = {})
        update(options.merge(upsert: true))
      end

      def find_and_modify(options = {})
        dao.find_and_modify(options.merge(query: query.wheres, update: query.updates))
      end

    end
  end
end
