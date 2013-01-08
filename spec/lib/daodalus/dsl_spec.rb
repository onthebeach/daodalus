require 'spec_helper'

class DSLTestDAO
  extend Daodalus::DSL

  def self.test_where
    where.or(
      where(:cats).eq(3),
      where(:dogs).eq(2)
    )
  end

  def self.test_match
    match(:cats).eq(3)
  end

  def self.test_group
    group(:breed).avg(:paws).match(:cats).eq(3)
  end

  def self.test_limit
    limit(10).group(:breed)
  end

  def self.test_skip
    skip(10).limit(5)
  end

  def self.test_sort
    sort(:cats, [:dogs, :desc]).skip(3)
  end

  def self.test_unwind
    unwind(:cats).sort('cats.paws')
  end

  def self.test_project
    project(:_id, :total).and(
      project(:cats),
      project(:koi).plus(:goldfish).as(:fish)
    ).as(:pets).
      unwind(:total)
  end
end

module Daodalus
  describe DSL do

    describe '#where' do
      it 'builds a where query' do
        DSLTestDAO.test_where.
          criteria.
          should eq ({'$or' => [{'cats'=>3},{'dogs'=>2}]})
      end
    end

    describe '#match' do
      it 'builds a match query' do
        DSLTestDAO.test_match.to_query.
          should eq [{'$match' => {'cats' => 3}}]
      end
    end

    describe '#group' do
      it 'builds a group query' do
        DSLTestDAO.test_group.to_query.
          should eq [
            {'$group' => {'_id' => '$breed', 'paws' => {'$avg' => '$paws'}}},
            {'$match' => {'cats' => 3}}]
      end
    end

    describe '#skip' do
      it 'builds a skip query' do
        DSLTestDAO.test_skip.to_query.
          should eq [{"$skip"=>10}, {"$limit"=> 5}]
      end
    end

    describe '#sort' do
      it 'builds a sort query' do
        DSLTestDAO.test_sort.to_query.
          should eq [{"$sort"=>{"cats"=>1, "dogs"=>-1}}, {"$skip"=>3}]
      end
    end

    describe '#unwind' do
      it 'builds an unwind query' do
        DSLTestDAO.test_unwind.to_query.
          should eq [{"$unwind"=>"$cats"}, {"$sort"=>{"cats.paws"=>1}}]
      end
    end

    describe '#limit' do
      it 'builds a limit query' do
        DSLTestDAO.test_limit.to_query.
          should eq [{"$limit"=>10}, {"$group"=>{"_id"=>"$breed"}}]
      end
    end

    describe '#project' do
      it 'builds a project query' do
        DSLTestDAO.test_project.to_query.
          should eq [
            {"$project"=> {"_id"=>'$_id', "total"=>'$total', "pets"=>{"cats"=>'$cats', "fish"=>{"$add"=>["$koi", "$goldfish"]}}}},
            {'$unwind' => '$total'}]
      end
    end
  end
end
