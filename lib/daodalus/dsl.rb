module Daodalus
  module DSL
    include Clause
    include Queries
    include Updates
    include Aggregations

    def query
      Query.new
    end

    def pipeline
      []
    end

    def dao
      self
    end

  end
end
