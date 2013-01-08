require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Match do

        before :each do
          CatDAO.remove_all
          CatDAO.insert(name: 'Felix',   stray: false, paws: 4)
          CatDAO.insert(name: 'Jeffrey', stray: false, paws: 3)
          CatDAO.insert(name: 'Louise',  stray: false, paws: 3)
          CatDAO.insert(name: 'Cat',     stray: true,  paws: 3)
        end

        subject { CatDAO }

        it "can match on not equal" do
          subject.
            match(:paws).ne(3).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Felix', 'stray' => false, 'paws' => 4}
          ]
        end

        it "can match on equal" do
          subject.
            match(:paws).eq(4).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Felix', 'stray' => false, 'paws' => 4}
          ]
        end

        it "can match on less than" do
          subject.
            match(:paws).lt(4).
            sort([:name, -1]).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Louise', 'stray' => false, 'paws' => 3},
              {'name' => 'Jeffrey', 'stray' => false, 'paws' => 3},
              {'name' => 'Cat', 'stray' => true, 'paws' => 3}
          ]
        end

        it "can match on greater than" do
          subject.
            match(:paws).gt(3).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Felix', 'stray' => false, 'paws' => 4}
          ]
        end

        it "can match on less than or equal" do
          subject.
            match(:paws).lte(3).
            sort([:name, -1]).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Louise', 'stray' => false, 'paws' => 3},
              {'name' => 'Jeffrey', 'stray' => false, 'paws' => 3},
              {'name' => 'Cat', 'stray' => true, 'paws' => 3}
          ]
        end

        it "can match on greater than or equal" do
          subject.
            match(:paws).gte(4).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Felix', 'stray' => false, 'paws' => 4}
          ]
        end

        it "can match on an array of values" do
          subject.
            match(:name).in('Louise', 'Jeffrey', 'Terry').
            sort([:name, -1]).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Louise', 'stray' => false, 'paws' => 3},
              {'name' => 'Jeffrey', 'stray' => false, 'paws' => 3}
          ]
        end

        it "can match on not being in an array of values" do
          subject.
            match(:name).nin('Louise', 'Jeffrey', 'Terry').
            sort([:name, -1]).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Felix', 'stray' => false, 'paws' => 4},
              {'name' => 'Cat', 'stray' => true, 'paws' => 3}
          ]
        end

        it 'can match using an "all" criteria' do
          subject.insert(name: 'Russell', scarves: ['yellow', 'purple', 'long'])
          subject.
            match(:scarves).all('yellow', 'long').
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Russell', 'scarves' => ["yellow", "purple", "long"]}
          ]
        end

        it 'can match on the size of an array' do
          subject.insert(name: 'Russell', scarves: ['yellow', 'purple', 'long'])
          subject.
            match(:scarves).size(3).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Russell', 'scarves' => ["yellow", "purple", "long"]}
          ]
        end

        it 'can match on the existence of fields' do
          subject.insert(name: 'Russell', scarves: ['yellow', 'purple', 'long'])
          subject.
            match(:scarves).exists.
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Russell', 'scarves' => ["yellow", "purple", "long"]}
          ]
        end

        it 'can match on the non-existence of fields' do
          subject.insert(name: 'Russell', scarves: ['yellow', 'purple', 'long'])
          subject.
            match(:scarves).does_not_exist.
            sort([:name, -1]).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Louise', 'stray' => false, 'paws' => 3},
              {'name' => 'Jeffrey', 'stray' => false, 'paws' => 3},
              {'name' => 'Felix', 'stray' => false, 'paws' => 4},
              {'name' => 'Cat', 'stray' => true, 'paws' => 3}
          ]
        end

        it 'can match on the result of a modulus function' do
          subject.match(:paws).
            mod(3,1).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Felix', 'stray' => false, 'paws' => 4}
          ]
        end

        it 'can negate clauses' do
          subject.
            match(:paws).not.lt(4).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [{'name' => 'Felix', 'stray' => false, 'paws' => 4}]
        end

        it 'can run nor clauses' do
          subject.insert(name: 'Russell', scarves: ['yellow', 'purple', 'long'])
          subject.
            match.nor(
              subject.match(:paws).lt(4),
              subject.match(:scarves).exists
            ).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [{'name' => 'Felix', 'stray' => false, 'paws' => 4}]
        end

        it 'can run or clauses' do
          subject.insert(name: 'Russell', scarves: ['yellow', 'purple', 'long'])
          subject.
            match.or(
              subject.match(:paws).gte(4),
              subject.match(:scarves).exists
            ).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Felix', 'stray' => false, 'paws' => 4},
              {'name' => 'Russell', 'scarves' => ["yellow", "purple", "long"]}]
        end

        it 'can run elemMatch clauses' do
          subject.insert(name: 'Russell', hats: [{ flat: true, top: false}])
          subject.
            match(:hats).elem_match(
              subject.match(:flat).eq(true).
              and(:top).eq(false)
            ).
            tap{|x| puts x.to_query.inspect}.
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [{"name"=>"Russell", "hats"=>[{"flat"=>true, "top"=>false}]}]
        end
      end
    end
  end
end
