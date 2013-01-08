require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Project do
        let (:dao) { stub }
        let (:query) { Limit.new(dao, 30) }

        it 'takes a field to project (the _id field is excluded by default)' do
          query.project(:cats).to_mongo.should eq ({'$project' => {'_id'=> 0, 'cats' => 1}})
        end

        it 'is possible to select the _id field in the project' do
          query.project(:_id).to_mongo.should eq ({'$project' => {'_id' => 1}})
        end

        it 'is possible to project multiple fields' do
          query.project(:cats, :mice).with(:dogs, :fish).projection.
            should eq ({'cats' => 1, 'dogs' => 1, 'mice' => 1, 'fish' => 1})
        end

        it 'can take new names for fields' do
          query.project('animals.cats').as(:cats).projection.
            should eq ({'cats' => '$animals.cats'})
        end

        it 'is possible to chain projects using with' do
          query.project('animals.cats').as(:cats).
            with(:dogs, :fish).projection.
            should eq ({'cats' => '$animals.cats', 'dogs' => 1, 'fish' => 1})
        end

        describe "#plus" do
          it 'builds an add operator' do
            query.project(:cats).plus(:dogs, 3).as(:pets).projection.
              should eq ({'pets' => { '$add' => ['$cats', '$dogs', 3]}})
          end

          it 'allows chaining with other projects' do
            query.project(:cats).plus(:dogs, 3).as(:pets).with(:fish).projection.
              should eq ({'pets' => { '$add' => ['$cats', '$dogs', 3]}, 'fish' => 1})
          end
        end

        describe "#divided_by" do
          it 'builds a divide operator' do
            query.project(:cats).divided_by(:dogs).as(:pets).projection.
              should eq ({'pets' => { '$divide' => ['$cats', '$dogs']}})
          end
        end

        describe "#mod" do
          it 'builds a mod operator' do
            query.project(:cats).mod(3).as(:pets).projection.
              should eq ({'pets' => { '$mod' => ['$cats', 3]}})
          end
        end

        describe "#multiplied_by" do
          it 'builds a multiply operator' do
            query.project('cats').multiplied_by('dogs', 3).as(:pets).projection.
              should eq ({'pets' => { '$multiply' => ['$cats', '$dogs', 3]}})
          end
        end

        describe "#minus" do
          it 'builds a subtract operator' do
            query.project('cats').minus('dogs').as(:pets).projection.
              should eq ({'pets' => { '$subtract' => ['$cats', '$dogs']}})
          end
        end

        it 'can create nested documents' do
          query.
            project(
              Project.new(dao, ['animals.cats'], 1, {}).as(:cats),
              Project.new(dao, ['animals.dogs'], 1, {}).plus(1).as(:dogs),
            ).as(:pets).projection.
            should eq ({'pets' => { 'cats' => '$animals.cats', 'dogs' => {'$add' => ['$animals.dogs', 1]}}})
        end

      end
    end
  end
end
