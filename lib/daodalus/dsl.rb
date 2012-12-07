module Daodalus
  module DSL
    include Queries
    include Updates
    include Aggregations

    def where(field=nil)
      Where.new(self, field)
    end

  end
end
