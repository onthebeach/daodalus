module Daodalus
  module DSL

    def where field
      Where.new(self, query, field.to_s)
    end

    def query
      Query.new
    end
  end
end
