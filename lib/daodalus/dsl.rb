module Daodalus
  module DSL

    def where(field=nil)
      Where.new(self, field)
    end

    def select(*fields)
      Select.new(self, fields)
    end

    def set(field, value)
      Update.new(dao).set(field, value)
    end

    def match(field=nil)
      Aggregation::Match.new(self, field)
    end

    def group(*keys)
      Aggregation::Group.new(self, keys)
    end

    def limit(total)
      Aggregation::Limit.new(self, total)
    end

    def skip(total)
      Aggregation::Skip.new(self, total)
    end

    def sort(*fields)
      Aggregation::Sort.new(self, fields)
    end

    def unwind(field)
      Aggregation::Unwind.new(self, field)
    end

    def project(*fields)
      Aggregation::Project.new(self, fields, 1, {})
    end

  end
end
