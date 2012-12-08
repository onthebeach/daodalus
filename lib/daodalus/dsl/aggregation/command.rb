module Daodalus
  module DSL
    module Aggregation
      module Command

        def match(field=nil)
          Match.new(dao, field, {}, to_query)
        end

        def group(*keys)
          Group.new(dao, keys, {}, to_query)
        end

        def to_query
          if to_mongo.empty? then query else query + [to_mongo] end
        end

        private

        def field_as_operator(field)
          "$#{field}"
        end

        def to_mongo
          raise NotImplementedError, "Including classes must implement this"
        end

        def operator
          raise NotImplementedError, "Including classes must implement this"
        end

        def dao
          raise NotImplementedError, "Including classes must implement this"
        end

        def query
          raise NotImplementedError, "Including classes must implement this"
        end

        def criteria
          raise NotImplementedError, "Including classes must implement this"
        end

      end
    end
  end
end
