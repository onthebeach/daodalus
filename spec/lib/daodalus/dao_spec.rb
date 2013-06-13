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

  end
end
