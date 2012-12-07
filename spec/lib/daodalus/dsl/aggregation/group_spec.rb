require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Group do
        let (:dao) { stub }
        let (:group) { ->(*keys) { Group.new(dao, keys) } }

        describe "#to_query" do
          context 'when a single key is passed' do
            it 'uses that key as the _id' do
              group.(:cats).to_query.first.fetch('$group').
                should eq ({'_id' => '$cats'})
            end
          end
          context 'when an array of keys is passed' do
            it 'uses matching names for the id document' do
              group.(:cats, :dogs).to_query.first.fetch('$group').
                should eq ({'_id' => { 'cats' => '$cats', 'dogs' => '$dogs'}})
            end
          end
          context 'when a hash of key to key names is passed' do
            it 'uses the key name pairs' do
              group.(cats: "animals.cats", dogs: "animals.dogs").to_query.first.fetch('$group').
                should eq ({'_id' => { 'cats' => '$animals.cats', 'dogs' => '$animals.dogs'}})
            end
          end
        end

        describe "#add_to_set" do
          it 'constructs the correct aggregation query' do
            group.(:cats).add_to_set(:paws).to_query.first.fetch('$group').
              should eq ({'_id' => '$cats', 'paws' => {'$addToSet' => '$paws'}})
          end
        end

        describe "#first" do
          it 'constructs the correct aggregation query' do
            group.(:cats).first(paws: "cats.paws").to_query.first.fetch('$group').
              should eq ({'_id' => '$cats', 'paws' => {'$first' => '$cats.paws'}})
          end
        end

        describe "#last" do
          it 'constructs the correct aggregation query' do
            group.(:cats).last(paws: "cats.paws").to_query.first.fetch('$group').
              should eq ({'_id' => '$cats', 'paws' => {'$last' => '$cats.paws'}})
          end
        end

        describe "#max" do
          it 'constructs the correct aggregation query' do
            group.(:cats).max(paws: "cats.paws").to_query.first.fetch('$group').
              should eq ({'_id' => '$cats', 'paws' => {'$max' => '$cats.paws'}})
          end
        end

        describe "#min" do
          it 'constructs the correct aggregation query' do
            group.(:cats).min(paws: "cats.paws").to_query.first.fetch('$group').
              should eq ({'_id' => '$cats', 'paws' => {'$min' => '$cats.paws'}})
          end
        end

        describe "#avg" do
          it 'constructs the correct aggregation query' do
            group.(:cats).avg(paws: "cats.paws").to_query.first.fetch('$group').
              should eq ({'_id' => '$cats', 'paws' => {'$avg' => '$cats.paws'}})
          end
        end

        describe "#push" do
          it 'constructs the correct aggregation query' do
            group.(:cats).push(paws: "cats.paws").to_query.first.fetch('$group').
              should eq ({'_id' => '$cats', 'paws' => {'$push' => '$cats.paws'}})
          end
        end

        describe "#sum" do
          it 'constructs the correct aggregation query' do
            group.(:cats).sum(paws: "cats.paws").to_query.first.fetch('$group').
              should eq ({'_id' => '$cats', 'paws' => {'$sum' => '$cats.paws'}})
          end
        end

      end
    end
  end
end
