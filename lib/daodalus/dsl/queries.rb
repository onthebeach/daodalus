module Daodalus
  module DSL
    module Queries

      def find(options = {})
        options = options.merge(fields: query.selects) if query.has_selects?
        dao.find(query.wheres, options)
      end

      def find_one(options = {})
        options = options.merge(fields: query.selects) if query.has_selects?
        dao.find_one(query.wheres, options)
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
