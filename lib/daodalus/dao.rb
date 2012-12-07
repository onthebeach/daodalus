module Daodalus
  module DAO

    private

    def target(conn, coll)
      @connection_name = conn.to_s
      @collection_name = coll.to_s
    end

    def db
      Daodalus::Pool.instance[connection_name].db
    end

    def collection
      db[collection_name]
    end

    attr_reader :collection_name
    attr_reader :connection_name
  end
end
