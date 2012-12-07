require 'spec_helper'

module Daodalus
  module DSL
    describe Where do
      let (:dao) { stub }
      let (:query) { Where.new(dao, :cats) }

      describe "#eq" do
        it 'adds an equal clause to the where' do
          query.eq(5).where_clause.should eq ({'cats' => 5})
        end
        it 'can also be called using an alias' do
          query.equals(5).where_clause.should eq ({'cats' => 5})
        end
      end

      describe "#ne" do
        it 'adds a not equal clause to the where' do
          query.ne(5).where_clause.should eq ({'cats' => { '$ne' => 5 }})
        end
        it 'can also be called using an alias' do
          query.not_equal(5).where_clause.should eq ({'cats' => { '$ne' => 5 }})
        end
      end

      describe "#lt" do
        it 'adds a less than clause to the where' do
          query.lt(5).where_clause.should eq ({'cats' => { '$lt' => 5 }})
        end
        it 'can also be called using an alias' do
          query.less_than(5).where_clause.should eq ({'cats' => { '$lt' => 5 }})
        end
      end

      describe "#lte" do
        it 'adds a less than or equal clause to the where' do
          query.lte(5).where_clause.should eq ({'cats' => { '$lte' => 5 }})
        end
        it 'can also be called using an alias' do
          query.less_than_or_equal(5).where_clause.should eq ({'cats' => { '$lte' => 5 }})
        end
      end

      describe "#gt" do
        it 'adds a greater than clause to the where' do
          query.gt(5).where_clause.should eq ({'cats' => { '$gt' => 5 }})
        end
        it 'can also be called using an alias' do
          query.greater_than(5).where_clause.should eq ({'cats' => { '$gt' => 5 }})
        end
      end

      describe "#gte" do
        it 'adds a greater than or equal clause to the where' do
          query.gte(5).where_clause.should eq ({'cats' => { '$gte' => 5 }})
        end
        it 'can also be called using an alias' do
          query.greater_than_or_equal(5).where_clause.should eq ({'cats' => { '$gte' => 5 }})
        end
      end

      describe "#in" do
        it 'adds an in clause to the where' do
          query.in(5,6).where_clause.should eq ({'cats' => { '$in' => [5,6] }})
        end
      end

      describe "#nin" do
        it 'adds a not in clause to the where' do
          query.nin(5,6).where_clause.should eq ({'cats' => { '$nin' => [5,6] }})
        end
        it 'can also be called using an alias' do
          query.not_in(5,6).where_clause.should eq ({'cats' => { '$nin' => [5,6] }})
        end
      end

      describe "#all" do
        it 'adds an all clause to the where' do
          query.all(5,6).where_clause.should eq ({'cats' => { '$all' => [5,6] }})
        end
      end

      describe "#size" do
        it 'adds a size clause to the where' do
          query.size(5).where_clause.should eq ({'cats' => { '$size' => 5 }})
        end
      end

      describe "#mod" do
        it 'adds a mod clause to the where' do
          query.mod(6,2).where_clause.should eq ({'cats' => { '$mod' => [6,2] }})
        end
        it 'can also be called using an alias' do
          query.modulus(6,2).where_clause.should eq ({'cats' => { '$mod' => [6,2] }})
        end
      end

      describe "#exists" do
        it 'adds an exists clause to the where' do
          query.exists.where_clause.should eq ({'cats' => { '$exists' => true }})
        end
      end

      describe "#size" do
        it 'adds a not exists clause to the where' do
          query.does_not_exist.where_clause.should eq ({'cats' => { '$exists' => false }})
        end
      end

      describe "#and" do
        context 'when passed a symbol or string' do
          it 'allows chaining of where clauses' do
            query.gt(5).
              and(:dogs).lt(4).
              where_clause.
              should eq ({'cats' => {'$gt' => 5}, 'dogs' => {'$lt' => 4}})
          end
        end
        context 'when passed an array of clauses' do
          it 'adds a logical and clause to the where' do
            query.and(
              Where.new(dao, :cats).eq(5),
              Where.new(dao, :dogs).lt(4)).
              where_clause.
              should eq ({'$and' => [{'cats' => 5},{'dogs' => { '$lt' => 4}}]})
          end
        end
        context 'when passed something else' do
          it 'raises an error' do
            expect { query.and(1,2,3) }.to raise_error ArgumentError
          end
        end
      end

      describe "#or" do
        it 'adds a logical or clause to the where' do
          query.or(
            Where.new(dao, :cats).eq(5),
            Where.new(dao, :dogs).lt(4)).
            where_clause.
            should eq ({'$or' => [{'cats' => 5},{'dogs' => { '$lt' => 4}}]})
        end
      end

      describe "#nor" do
        it 'adds a logical nor clause to the where' do
          query.nor(
            Where.new(dao, :cats).eq(5),
            Where.new(dao, :dogs).lt(4)).
            where_clause.
            should eq ({'$nor' => [{'cats' => 5},{'dogs' => { '$lt' => 4}}]})
        end
      end

      describe "#not" do
        it 'adds a logical not clause to the where' do
          query.not(Where.new(dao, :cats).eq(5)).
            where_clause.
            should eq ({'$not' => {'cats' => 5}})
        end
      end

      describe "#nor" do
        it 'adds a logical nor clause to the where' do
          query.nor(
            Where.new(dao, :cats).eq(5),
            Where.new(dao, :dogs).lt(4)).
            where_clause.
            should eq ({'$nor' => [{'cats' => 5},{'dogs' => { '$lt' => 4}}]})
        end
      end

      describe "#elemMatch" do
        it 'adds an elemMatch clause to the where' do
          query.elem_match(Where.new(dao, :feet).eq(3)).
            where_clause.
            should eq ({'cats' => {'$elemMatch' => {'feet' => 3}}})
        end
      end

    end
  end
end
