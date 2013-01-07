require 'spec_helper'

class DSLIntegrationTests
  extend Daodalus::DSL
  target :cathouse, :cats

end

describe DSLIntegrationTests do

  before :each do
    DSLIntegrationTests.remove_all
  end

  describe "#find" do

    subject { DSLIntegrationTests }

    it 'works when the last link in the chain is a where clause' do
      subject.insert(name: "Felix", paws: 4)

      subject.
        select(:paws).
        where(:name).eq('Felix').
        find.first.should eq ({"paws" => 4})
    end

    it 'works when the last link in the chain is a select clause' do
      subject.insert(name: "Ginger", paws: 3)

      subject.
        where(:name).eq("Ginger").
        select(:paws).
        find.first.should eq ({"paws" => 3})
    end

  end

  describe "#find_one" do

    subject { DSLIntegrationTests }

    it 'works when the last link in the chain is a where clause' do
      subject.insert(name: "Felix", paws: 4)

      subject.select(:paws).
        where(:name).eq('Felix').
        find_one.should eq ({"paws" => 4})
    end

    it 'works when the last link in the chain is a select clause' do
      subject.send(:insert, name: "Ginger", paws: 3)

      subject.
        where(:name).eq("Ginger").
        select(:paws).
        find_one.should eq ({"paws" => 3})
    end

  end
end
