module Daodalus
  module DSL

    def where(field=nil)
      Where.new(self, field)
    end

    def match(field=nil)
      Match.new(self, field)
    end

  end
end
