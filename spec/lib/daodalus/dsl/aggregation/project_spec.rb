require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Project do
        let (:dao) { stub }
        let (:query) { Limit.new(dao, 30) }

        it 'takes a field to project (the _id field is excluded by default)' do
          query.project(:cats).projection.should eq ({'_id'=> 0, 'cats' => 1})
        end

        it 'is possible to select the _id field in the project' do
          query.project(:_id).projection.should eq ({'_id' => 1})
        end

        it 'is possible to project multiple fields' do
          query.project(:cats, :dogs).projection.should eq ({'_id' => 0, 'cats' => 1, 'dogs' => 1})
        end

        it 'can take new names for fields' do
          pending
          query.project(:cats).as('animals.cats').projection.
            should eq ({'_id' => 0, 'cats' => '$animals.cats'})
        end
      end
    end
  end
end
          #query.
            #project(:title).
            #with(:stats).as(
              #project(:pv).as('pageViews'),
              #project(:foo).as('other.foo'),
              #project(:dpv).as('pageViews').plus(10),
              #project(:dpv).as('pageViews').minus('cats'),
              #project(:dpv).as('pageViews').divided_by(10),
              #project(:dpv).as('pageViews').mod(10),
              #project(:dpv).as('pageViews').multiplied_by(10, 'cats')
            #).
            #with(:cats).as('animals.cats')
