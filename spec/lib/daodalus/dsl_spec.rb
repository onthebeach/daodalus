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
    match(:cats).eq(3).
      group(:breed).avg(:paws)
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
          should eq ([{'$match' => {'cats' => 3}}])
      end
    end

    describe '#group' do
      it 'builds a group query' do
        DSLTestDAO.test_group.to_query.
          should eq ([
            {'$match' => {'cats' => 3}},
            {'$group' => {'_id' => '$breed', 'paws' => {'$avg' => '$paws'}}}])
      end
    end
  end
end
