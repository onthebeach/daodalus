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

      before :each do
        TestDAO.send(:remove_all)
        TestDAO.send(:insert, name: 'Felix', paws: 4)
      end

      describe "#find_one" do
        it "performs a find_one command" do
          TestDAO.send(:find_one, name: "Felix").fetch('paws').should eq 4
        end
      end

      describe "#find" do
        it "performs a find command" do
          TestDAO.send(:find, name: "Felix").first.fetch('paws').should eq 4
        end
      end

      describe "#insert" do
        it "performs a insert command" do
          TestDAO.send(:insert, name: "Hatty", paws: 3)
          TestDAO.send(:find).count.should eq 2
        end
      end

      describe "#update" do
        it "performs a update command" do
          TestDAO.send(:update, {name: 'Felix'}, {'$inc' => {paws: 1}})
          TestDAO.send(:find_one).fetch('paws').should eq 5
        end
      end

      describe "#remove" do
        it "performs a remove command" do
          TestDAO.send(:remove, name: 'Felix')
          TestDAO.send(:find_one).should be_nil
        end
      end

      describe "#remove_all" do
        it "empties the collection" do
          TestDAO.send(:remove_all)
          TestDAO.send(:find).count.should be_zero
        end
      end

      describe "#count" do
        it "returns a count" do
          TestDAO.send(:insert, name: "Felix", paws: 3)
          TestDAO.send(:count, name: 'Felix').should eq 2
        end
      end

      describe "#find_and_modify" do
        it "returns a find_and_modify" do
          TestDAO.send(:find_and_modify, 'query' => {name: 'Felix'}, 'update' => {'$inc' =>{'paws' => 2}})
          TestDAO.send(:find_one).fetch('paws').should eq 6
        end
      end

      describe "#find_or_create" do
        context "when a matching record exists" do
          it "returns the record" do
            TestDAO.send(:find_or_create, name: 'Felix').fetch('paws').should eq 4
          end
        end
        context "when no matching record exists" do
          it "creates a new record" do
            TestDAO.send(:find_or_create, name: 'CATFACE')
            TestDAO.send(:find_one, name: "CATFACE").should_not be_nil
          end
        end
      end

    end
  end
end
