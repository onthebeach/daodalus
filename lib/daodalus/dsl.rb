module Daodalus
  module DSL
    include DAO

    def where(field=nil)
      Where.new(self, field)
    end

    def select(*fields)
      Select.new(self, fields)
    end

    def set(field, value)
      Update.new(self).set(field, value)
    end

    def unset(field)
      Update.new(self).unset(field)
    end

    def inc(field, amount=1)
      Update.new(self).inc(field, amount)
    end

    def rename(field, value)
      Update.new(self).rename(field, value)
    end

    def push(field, *values)
      Update.new(self).push(field, *values)
    end

    def push_all(field, values)
      Update.new(self).push_all(field, values)
    end

    def add_to_set(field, *values)
      Update.new(self).add_to_set(field, *values)
    end

    def add_each_to_set(field, values)
      Update.new(self).add_each_to_set(field, values)
    end

    def pop_first(field)
      Update.new(self).pop_first(field)
    end

    def pop_last(field)
      Update.new(self).pop_last(field)
    end

    def pull(field, *values)
      Update.new(self).pull(field, *values)
    end

    def pull_all(field, values)
      Update.new(self).pull_all(field, values)
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
