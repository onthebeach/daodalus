module Daodalus
  module DSL
    module Aggregation
      class Project
        include Command

        def initialize(dao, fields, projection={}, query=[])
          @dao = dao
          @fields = fields
          @projection = projection
          @query = query
        end

        def operator
          '$project'
        end

        def to_mongo
          {operator => total}
        end

        #def as(field)
          #Project.new(dao, {fields.first => field}, projection, query)
        #end

        def projection
          fields.reduce({'_id' => 0}){ |acc, f| acc.merge(f.to_s => 1) }
        end

        private

        attr_reader :dao, :fields, :query

      end
    end
  end
end
