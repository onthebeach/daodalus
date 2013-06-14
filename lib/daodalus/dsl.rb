module Daodalus
  module DSL

    def where *fields
      Where.new(self, query, fields)
    end

    def select *fields
      Select.new(self, query, fields)
    end

    def query
      Query.new
    end
  end
end
