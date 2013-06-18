module Daodalus
  module DSL
    module Queries

      def find(options = {})
        dao.find(query.wheres, options.merge(fields: query.selects))
      end

      def find_one(options = {})
        dao.find_one(query.wheres, options.merge(fields: query.selects))
      end

      def where field=nil
        if field.is_a? Hash
          Where.new(dao, query.where(field), nil)
        else
          Where.new(dao, query, field)
        end
      end

      def select *fields
        Select.new(dao, query, fields)
      end

    end
  end
end
