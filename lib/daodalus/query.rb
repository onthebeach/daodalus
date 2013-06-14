module Daodalus
  class Query

    def initialize(wheres={}, selects={}, updates={})
      @wheres  = wheres
      @selects = selects
      @updates = updates
    end
    attr_reader :wheres, :selects, :updates

    def where(clause)
      Query.new(wheres.merge(clause), selects, updates)
    end

  end
end
