require 'spec_helper'

module Daodalus
  describe DAO do
    describe '.target' do

      class TestDAO
        extend DAO
        target :cathouse, :kittens
      end

      it 'allows setting of the connection and collection' do
        TestDAO
      end

      class TestDAOInstance
        include DAO
        target :cathouse, :kittens
      end

      it 'also allows creating instances of a dao' do
        dao = TestDAOInstance.new
        dao.remove_all
        dao.insert(name: 'Felix')
        dao.find_one.fetch('name').should eq 'Felix'
      end

      before :each do
        TestDAO.remove_all
        TestDAO.insert(name: 'Felix', paws: 4)
      end

      describe "#save" do
        it 'creates or updates a record' do
          TestDAO.save(name: 'Calhoun')
          TestDAO.find(name: 'Calhoun').count.should eq 1
          TestDAO.save(TestDAO.find_one(name: 'Calhoun'))
          TestDAO.find(name: 'Calhoun').count.should eq 1
        end
      end

      describe "#find_one" do
        it "performs a find_one command" do
          TestDAO.find_one(name: "Felix").fetch('paws').should eq 4
        end
      end

      describe "#find" do
        it "performs a find command" do
          TestDAO.find(name: "Felix").first.fetch('paws').should eq 4
        end
      end

      describe "#insert" do
        it "performs a insert command" do
          TestDAO.insert(name: "Hatty", paws: 3)
          TestDAO.find.count.should eq 2
        end
      end

      describe "#update" do
        it "performs a update command" do
          TestDAO.update({name: 'Felix'}, {'$inc' => {paws: 1}})
          TestDAO.find_one.fetch('paws').should eq 5
        end
      end

      describe "#remove" do
        it "performs a remove command" do
          TestDAO.remove(name: 'Felix')
          TestDAO.find_one.should be_nil
        end
      end

      describe "#remove_all" do
        it "empties the collection" do
          TestDAO.remove_all
          TestDAO.find.count.should be_zero
        end
      end

      describe "#count" do
        it "returns a count" do
          TestDAO.insert(name: "Felix", paws: 3)
          TestDAO.count(name: 'Felix').should eq 2
        end
      end

      describe "#find_and_modify" do
        it "returns a find_and_modify" do
          TestDAO.find_and_modify('query' => {name: 'Felix'}, 'update' => {'$inc' =>{'paws' => 2}})
          TestDAO.find_one.fetch('paws').should eq 6
        end
      end

    end
  end
end
