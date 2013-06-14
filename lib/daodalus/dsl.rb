module Daodalus
  module DSL

    def where field=nil
      Where.new(self, query, field)
    end

    def select *fields
      Select.new(self, query, fields)
    end

    def query
      Query.new
    end
  end
end
