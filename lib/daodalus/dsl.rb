module Daodalus
  module DSL
    include Clause

    def query
      Query.new
    end

    def dao
      self
    end
  end
end
