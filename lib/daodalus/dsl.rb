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

    def unset(field)
      Update.new(dao).unset(field)
    end

    def inc(field, amount=1)
      Update.new(dao).inc(field, amount)
    end

    def rename(field, value)
      Update.new(dao).rename(field, value)
    end

    def push(field, *values)
      Update.new(dao).push(field, *values)
    end

    def push_all(field, *values)
      Update.new(dao).push_all(field, *values)
    end

    def add_to_set(field, *values)
      Update.new(dao).add_to_set(field, *values)
    end

    def pop_first(field)
      Update.new(dao).pop_first(field)
    end

    def pop_last(field)
      Update.new(dao).pop_last(field)
    end

    def pull(field, *values)
      Update.new(dao).pull(field, *values)
    end

    def pull_all(field, *values)
      Update.new(dao).pull_all(field, *values)
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
