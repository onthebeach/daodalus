module Daodalus
  module DSL

    def where(field=nil)
      Where.new(self, field)
    end

    def match(field=nil)
      Aggregation::Match.new(self, field)
    end

    def group(*keys)
      Aggregation::Group.new(self, keys)
    end

  end
end
