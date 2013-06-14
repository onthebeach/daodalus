module Daodalus
  class Query

    def initialize(wheres={}, selects={}, updates={})
      @wheres  = wheres
      @selects = selects
      @updates = updates
    end
    attr_reader :wheres, :updates

    def where clause
      Query.new(add_where(clause), selects, updates)
    end

    def select clause
      Query.new(wheres, selects.merge(clause), updates)
    end

    def selects
      { '_id' => 0 }.merge(@selects)
    end

    private

    def add_where clause
      wheres.merge(clause) do |f, a, b|
        if a.respond_to?(:merge) && b.respond_to?(:merge)
          a.merge(b)
        else
          raise InvalidQueryError.new("Invalid Query: Cannot merge clauses '#{a}' and '#{b}' for field '#{f}'")
        end
      end
    end

  end
end
