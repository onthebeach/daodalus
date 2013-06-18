require 'spec_helper'

module Daodalus
  describe Connection do

    let (:conn) { Mongo::MongoClient.new('localhost', 27017, pool_size: 5) }

    it 'allows connections to be registered and fetched by name' do
      Daodalus::Connection.register(conn, :animalhouse)
      Daodalus::Connection.fetch(:animalhouse).should eq conn
    end

    it 'allows the default connection to be registered and fetched without a name' do
      Daodalus::Connection.register(conn)
      Daodalus::Connection.fetch.should eq conn
    end

    it 'raises an invalid connection error if asked for a non-existent connection' do
      expect { Daodalus::Connection.fetch(:wrong) }.to raise_error InvalidConnectionError
    end
  end
end
