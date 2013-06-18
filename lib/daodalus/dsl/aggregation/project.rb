module Daodalus
  module DSL
    module Aggregation
      class Project
        include Aggregations

        def initialize(dao, aggregations, projection = {}, keys)
          @dao          = dao
          @aggregations = aggregations
          @projection   = projection
          @keys         = keys
        end

        def to_aggregation
          { '$project' => { '_id' => 0 }.merge(projection) }
        end

        def project(*keys)
          Project.new(dao, aggregations, projection, keys)
        end
        alias_method :and, :project

        def as(aka)
          Project.new(dao, aggregations, @projection, [aka => keys.first])
        end

        def eq(*others)
          Project.new(dao, aggregations, @projection, ['$eq' => keys + others])
        end

        def add(*others)
          Project.new(dao, aggregations, @projection, ['$add' => keys + others])
        end
        alias_method :plus, :add

        def divide(other)
          Project.new(dao, aggregations, @projection, ['$divide' => keys + [other]])
        end
        alias_method :divided_by, :divide

        def multiply(other)
          Project.new(dao, aggregations, @projection, ['$multiply' => keys + [other]])
        end
        alias_method :multiplied_by, :multiply

        def subtract(other)
          Project.new(dao, aggregations, @projection, ['$subtract' => keys + [other]])
        end
        alias_method :minus, :subtract

        def mod(other)
          Project.new(dao, aggregations, @projection, ['$mod' => keys + [other]])
        end

        protected

        def projection
          keys.reduce(@projection) do |acc, k|
            case k
            when Hash then acc.merge(hashify k)
            else acc.merge(k.to_s => 1)
            end
          end
        end

        private

        def hashify(key)
          case key
          when Hash then key.reduce({}) { |acc, (k,v)| acc.merge(k => hashify(v)) }
          when Project then hashify key.projection
          else key
          end
        end
        attr_reader :dao, :aggregations, :keys
      end
    end
  end
end
