require 'delegate'

module Daodalus
  class DAO
    extend Forwardable

    def initialize(db, collection, connection=:default)
      @db         = db
      @collection = collection
      @connection = connection
    end

    def coll
      @coll ||= Daodalus::Connection.fetch(connection)[db.to_s][collection.to_s]
    end

    delegate [
      :find,
      :update,
      :insert,
      :save,
      :remove,
      :remove_all,
      :count,
      :aggregate
    ] => :coll

    def find_one(*args)
      Option[coll.find_one(*args)]
    end

    def find_and_modify(*args)
      Option[coll.find_and_modify(*args)]
    end

    private

    attr_reader :db, :collection, :connection

  end
end
