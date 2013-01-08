module Daodalus
  module DSL
    module Aggregation
      module Operator

        def match(field=nil)
          Match.new(dao, field, {}, to_query)
        end

        def group(*keys)
          Group.new(dao, keys, {}, to_query)
        end

        def limit(total)
          Limit.new(dao, total, to_query)
        end

        def skip(total)
          Skip.new(dao, total, to_query)
        end

        def sort(*fields)
          Sort.new(dao, fields, to_query)
        end

        def unwind(field)
          Unwind.new(dao, field, to_query)
        end

        def project(*fields)
          Project.new(dao, fields, 1, {}, to_query)
        end

        def aggregate
          dao.aggregate(to_query)
        end

        def to_query
          if to_mongo.empty? then query else query + [to_mongo] end
        end

        def transform(&block)
          Transform.new(self, block)
        end

        private

        def field_as_operator(field)
          if field.is_a?(Fixnum) then field
          elsif field.is_a?(String) || field.is_a?(Symbol) then "$#{field}"
          else field end
        end

        ##
        # Classes that include this module are required to implement the
        # following methods:
        #
        # to_mongo - return the command in mongo format
        # operator - the mongo operator for the command
        # dao      - the original dao that started the chain
        # query    - the current query (not including the current operator)
        ##

      end
    end
  end
end
