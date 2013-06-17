module Daodalus
  module DSL
    module Updates

      def update(options = {})
        dao.update(query.wheres, query.updates, options)
      end

    end
  end
end
