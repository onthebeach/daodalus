module Daodalus
  class DAO

    def initialize(collection, connection = :default)
      @collection = collection
      @connection = connection
    end

  end
end
