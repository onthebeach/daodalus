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
      :find_one,
      :find_and_modify,
      :update,
      :insert,
      :save,
      :remove,
      :remove_all,
      :count,
      :aggregate
    ] => :coll

    private

    attr_reader :db, :collection, :connection

  end
end
