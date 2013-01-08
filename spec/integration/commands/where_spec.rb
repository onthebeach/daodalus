require 'spec_helper'

module Daodalus
  module DSL
    describe Where do

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
          where(:paws).ne(3).
          transform{|r| r.delete('_id'); r }.
          find.should eq [
            {'name' => 'Felix', 'stray' => false, 'paws' => 4}
        ]
      end

      it "can match on equal" do
        subject.
          where(:paws).eq(4).
          transform{|r| r.delete('_id'); r }.
          find.should eq [
            {'name' => 'Felix', 'stray' => false, 'paws' => 4}
        ]
      end

      it "can match on less than" do
        subject.
          where(:paws).lt(4).
          find.
          sort([:name, -1]).
          map{|r| r.delete('_id'); r}.
          should eq [
            {'name' => 'Louise', 'stray' => false, 'paws' => 3},
            {'name' => 'Jeffrey', 'stray' => false, 'paws' => 3},
            {'name' => 'Cat', 'stray' => true, 'paws' => 3}
        ]
      end

      it "can match on greater than" do
        subject.
          where(:paws).gt(3).
          transform{|r| r.delete('_id'); r }.
          find.should eq [
            {'name' => 'Felix', 'stray' => false, 'paws' => 4}
        ]
      end

      it "can match on less than or equal" do
        subject.
          where(:paws).lte(3).
          find.
          sort([:name, -1]).
          map{|r| r.delete('_id'); r}.
          should eq [
            {'name' => 'Louise', 'stray' => false, 'paws' => 3},
            {'name' => 'Jeffrey', 'stray' => false, 'paws' => 3},
            {'name' => 'Cat', 'stray' => true, 'paws' => 3}
        ]
      end

      it "can match on greater than or equal" do
        subject.
          where(:paws).gte(4).
          transform{|r| r.delete('_id'); r }.
          find.should eq [
            {'name' => 'Felix', 'stray' => false, 'paws' => 4}
        ]
      end

      it "can match on an array of values" do
        subject.
          where(:name).in('Louise', 'Jeffrey', 'Terry').
          find.
          sort([:name, -1]).
          map{|r| r.delete('_id'); r}.
          should eq [
            {'name' => 'Louise', 'stray' => false, 'paws' => 3},
            {'name' => 'Jeffrey', 'stray' => false, 'paws' => 3}
        ]
      end

      it "can match on not being in an array of values" do
        subject.
          where(:name).nin('Louise', 'Jeffrey', 'Terry').
          find.
          sort([:name, -1]).
          map{|r| r.delete('_id'); r}.
          should eq [
            {'name' => 'Felix', 'stray' => false, 'paws' => 4},
            {'name' => 'Cat', 'stray' => true, 'paws' => 3}
        ]
      end

      it 'can match using an "all" criteria' do
        subject.insert(name: 'Russell', scarves: ['yellow', 'purple', 'long'])
        subject.
          where(:scarves).all('yellow', 'long').
          transform{|r| r.delete('_id'); r }.
          find.should eq [
            {'name' => 'Russell', 'scarves' => ["yellow", "purple", "long"]}
        ]
      end

      it 'can match on the size of an array' do
        subject.insert(name: 'Russell', scarves: ['yellow', 'purple', 'long'])
        subject.
          where(:scarves).size(3).
          transform{|r| r.delete('_id'); r }.
          find.should eq [
            {'name' => 'Russell', 'scarves' => ["yellow", "purple", "long"]}
        ]
      end

      it 'can match on the existence of fields' do
        subject.insert(name: 'Russell', scarves: ['yellow', 'purple', 'long'])
        subject.
          where(:scarves).exists.
          transform{|r| r.delete('_id'); r }.
          find.should eq [
            {'name' => 'Russell', 'scarves' => ["yellow", "purple", "long"]}
        ]
      end

      it 'can match on the non-existence of fields' do
        subject.insert(name: 'Russell', scarves: ['yellow', 'purple', 'long'])
        subject.
          where(:scarves).does_not_exist.
          find.
          sort([:name, -1]).
          map{|r| r.delete('_id'); r}.
          should eq [
            {'name' => 'Louise', 'stray' => false, 'paws' => 3},
            {'name' => 'Jeffrey', 'stray' => false, 'paws' => 3},
            {'name' => 'Felix', 'stray' => false, 'paws' => 4},
            {'name' => 'Cat', 'stray' => true, 'paws' => 3}
        ]
      end

      it 'can match on the result of a modulus function' do
        subject.where(:paws).
          mod(3,1).
          transform{|r| r.delete('_id'); r }.
          find.should eq [
            {'name' => 'Felix', 'stray' => false, 'paws' => 4}
        ]
      end

      it 'can negate clauses' do
        subject.
          where(:paws).not.lt(4).
          transform{|r| r.delete('_id'); r }.
          find.should eq [{'name' => 'Felix', 'stray' => false, 'paws' => 4}]
      end

      it 'can run nor clauses' do
        subject.insert(name: 'Russell', scarves: ['yellow', 'purple', 'long'])
        subject.
          where.nor(
            subject.where(:paws).lt(4),
            subject.where(:scarves).exists
        ).
          transform{|r| r.delete('_id'); r }.
          find.should eq [{'name' => 'Felix', 'stray' => false, 'paws' => 4}]
      end

      it 'can run or clauses' do
        subject.insert(name: 'Russell', scarves: ['yellow', 'purple', 'long'])
        subject.
          where.or(
            subject.where(:paws).gte(4),
            subject.where(:scarves).exists
        ).
          transform{|r| r.delete('_id'); r }.
          find.should eq [
            {'name' => 'Felix', 'stray' => false, 'paws' => 4},
            {'name' => 'Russell', 'scarves' => ["yellow", "purple", "long"]}]
      end

      it 'can run elemMatch clauses' do
        subject.insert(name: 'Russell', hats: [{ flat: true, top: false}])
        subject.
          where(:hats).elem_match(
            subject.where(:flat).eq(true).
            and(:top).eq(false)
        ).
          transform{|r| r.delete('_id'); r }.
          find.should eq [{"name"=>"Russell", "hats"=>[{"flat"=>true, "top"=>false}]}]
      end
    end
  end
end
