module Daodalus
  module DSL
    module Aggregation
      class Project
        include Operator

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
          {operator => {'_id' => 0}.merge(projection) }
        end

        def as(key)
          Project.new(dao, [key], fields_as_value, @projection, query)
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
          fields.reduce(@projection) { |acc, f| acc.merge(f.to_s => value) }
        end

        def value
          field_as_operator(@value)
        end

        private

        def fields_as_value
          if fields.all? {|f| f.is_a?(Project) }
            fields.map(&:projection).reduce(:merge)
          elsif fields.is_a?(Array) && fields.length == 1
            fields.first
          else
            fields
          end
        end

        def with_array_operator(op, args)
          Project.new(dao, {op => arg_array(args)}, nil, @projection, query)
        end

        def arg_array(args)
          ([fields.first] + args).map{|a| field_as_operator(a) }
        end

        attr_reader :dao, :fields, :query

      end
    end
  end
end
