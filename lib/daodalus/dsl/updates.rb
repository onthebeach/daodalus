module Daodalus
  module DSL
    module Updates

      def update(options = {})
        dao.update(criteria, update_clause, options)
      end

      def upsert
        update(upsert: true)
      end

      def find_and_modify(options = {})
        dao.find_and_modify(options.merge(query: criteria, update: update_clause))
      end
    end
  end
end
