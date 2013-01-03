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

    def find_one(*args)
      collection.find_one(*args)
    end

    def find(*args)
      collection.find(*args)
    end

    def insert(*args)
      collection.insert(*args)
    end

    def update(*args)
      collection.update(*args)
    end

    def remove(*args)
      collection.remove(*args)
    end

    def count(*args)
      collection.find(*args).count
    end

    def find_or_create(*args)
      find_one(*args) || insert(*args)
    end

    def find_and_modify(*args)
      collection.find_and_modify(*args)
    end

    def aggregate(*args)
      collection.aggregate(*args)
    end

    attr_reader :collection_name
    attr_reader :connection_name
  end
end
