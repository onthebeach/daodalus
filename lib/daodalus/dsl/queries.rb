module Daodalus
  module DSL
    module Queries

      def find(options = {})
        dao.find(criteria, select_options.merge(options))
      end

      def find_one(options = {})
        dao.find_one(criteria, select_options.merge(options))
      end

      private

      def select_options
        if select_clause.empty? then {}
        else { fields: select_clause } end
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
