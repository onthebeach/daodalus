require 'spec_helper'

class TestDAO
  extend Daodalus::DSL

  def self.test_where
    where.or(
      where(:cats).eq(3),
      where(:dogs).eq(2)
    )
  end
end

module Daodalus
  describe DSL do

    describe '#where' do
      it 'builds a where query' do
        TestDAO.test_where.
          where_clause.
          should eq ({'$or' => [{'cats'=>3},{'dogs'=>2}]})
      end
    end
  end
end
