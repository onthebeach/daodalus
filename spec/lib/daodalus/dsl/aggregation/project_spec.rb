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
          query.project(:cats).as('animals.cats').projection.
            should eq ({'_id' => 0, 'cats' => '$animals.cats'})
        end

        it 'is possible to chain projects using with' do
          query.project(:cats).as('animals.cats').
            with(:dogs, :fish).projection.
            should eq ({'_id' => 0, 'cats' => '$animals.cats', 'dogs' => 1, 'fish' => 1})
        end

        describe "#plus" do
          it 'builds an add operator' do
            query.project(:pets).as('cats').plus('dogs', 3).projection.
              should eq ({'_id' => 0, 'pets' => { '$add' => ['$cats', '$dogs', 3]}})
          end

          it 'allows chaining with other projects' do
            query.project(:pets).as('cats').plus('dogs', 3).with(:fish).projection.
              should eq ({'_id' => 0, 'pets' => { '$add' => ['$cats', '$dogs', 3]}, 'fish' => 1})
          end
        end

        describe "#divided_by" do
          it 'builds a divide operator' do
            query.project(:pets).as('cats').divided_by('dogs').projection.
              should eq ({'_id' => 0, 'pets' => { '$divide' => ['$cats', '$dogs']}})
          end
        end

        describe "#mod" do
          it 'builds a mod operator' do
            query.project(:pets).as('cats').mod(3).projection.
              should eq ({'_id' => 0, 'pets' => { '$mod' => ['$cats', 3]}})
          end
        end

        describe "#multiplied_by" do
          it 'builds a multiply operator' do
            query.project(:pets).as('cats').multiplied_by('dogs', 3).projection.
              should eq ({'_id' => 0, 'pets' => { '$multiply' => ['$cats', '$dogs', 3]}})
          end
        end

        describe "#minus" do
          it 'builds a subtract operator' do
            query.project(:pets).as('cats').minus('dogs').projection.
              should eq ({'_id' => 0, 'pets' => { '$subtract' => ['$cats', '$dogs']}})
          end
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
