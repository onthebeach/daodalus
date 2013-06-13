require 'spec_helper'

module Daodalus
  describe DAO do

    it 'takes a collection and connection name' do
      expect { DAO.new(:cats, :animalhouse) }.to_not raise_error
    end

    it 'is not necessary to specify the connection name' do
      expect { DAO.new(:cats) }.to_not raise_error
    end

    let (:dao) { DAO.new(:cats) }

    it 'holds a connection to the mongo DB' do
      pending
    end
  end
end
