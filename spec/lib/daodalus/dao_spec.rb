require 'spec_helper'

module Daodalus
  describe DAO do

    it 'takes a collection and connection name' do
      expect { DAO.new(:animalhouse, :cats, :animalhouse) }.to_not raise_error
    end

    it 'is not necessary to specify the connection name' do
      expect { DAO.new(:animalhouse, :cats) }.to_not raise_error
    end

    let (:dao) { DAO.new(:animalhouse, :cats) }

    it 'holds a connection to the mongo DB collection' do
      dao.coll.should be_a Mongo::Collection
    end

    it 'delegates basic mongo methods to its coll' do
      dao.coll.should_receive(:find)
      dao.find
    end

    it 'returns an optional value for find_one' do
      dao.find_one(name: 'felix').should be_none
    end

    it 'returns an optional value for find_and_modify' do
      dao.find_and_modify(query: { name: 'felix'}, update: { '$set' => { name: 'cat' }}).should be_none
    end

  end
end
