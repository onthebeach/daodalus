module Daodalus
  module DSL
    module Aggregation
      class Project
        include Command

        def initialize(dao, fields, value, projection, query=[])
          @dao = dao
          @fields = fields
          @value = value
          @projection = projection
          @query = query
        end

        def operator
          '$project'
        end

        def to_mongo
          {operator => total}
        end

        def as(value)
          Project.new(dao, fields, value, projection, query)
        end

        def with(*fields)
          Project.new(dao, fields, 1, projection, query)
        end

        def plus(*args)
          with_array_operator('$add', args)
        end

        def minus(arg)
          with_array_operator('$subtract', [arg])
        end

        def divided_by(arg)
          with_array_operator('$divide', [arg])
        end

        def mod(arg)
          with_array_operator('$mod', [arg])
        end

        def multiplied_by(*args)
          with_array_operator('$multiply', args)
        end

        def projection
          fields.reduce(@projection){ |acc, f| acc.merge(f.to_s => value) }
        end

        def value
          field_as_operator(@value)
        end

        private

        def with_array_operator(op, args)
          Project.new(dao, fields, {op => arg_array(args)}, projection, query)
        end

        def arg_array(args)
          [value] + args.map{|a| field_as_operator(a) }
        end

        attr_reader :dao, :fields, :query

      end
    end
  end
end
