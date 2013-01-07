module Daodalus
  module DSL
    module Queries

      def find(options = {})
        dao.find(criteria, options.merge(fields: select_clause))
      end

      def find_one(options = {})
        dao.find_one(criteria, options.merge(fields: select_clause))
      end

      ##
      # Including classes must implement the following methods
      #
      # criteria - the query criteria
      # select_clause - the fields to project
      #
      ##

    end
  end
end
