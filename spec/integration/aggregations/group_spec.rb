require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Group do

        before :each do
          CatDAO.remove_all
          CatDAO.insert(name: 'Felix',   stray: false, paws: 4)
          CatDAO.insert(name: 'Jeffrey', stray: false, paws: 3)
          CatDAO.insert(name: 'Louise',  stray: false, paws: 17)
          CatDAO.insert(name: 'Cat',     stray: true,  paws: 2)
        end

        subject { CatDAO }

        it 'allows you to take the sum' do
          subject.
            group(:stray).
            sum(:paws).
            sort([:_id, -1]).
            aggregate.
            should eq [
              {"_id" => true,  "paws" => 2},
              {"_id" => false, "paws" => 24}]
        end

        it 'allows you to build a set of distinct values' do
          subject.
            group(:stray).
            add_to_set(:paws).
            sort([:_id, -1]).
            transform{|r| r.merge('paws' => r['paws'].sort) }.
            aggregate.
            should eq [
              {"_id" => true,  "paws" => [2]},
              {"_id" => false, "paws" => [3,4,17]}]
        end

        it 'allows you to take the first value for a group' do
          subject.
            sort(:name).
            group(:stray).
            first(:paws).
            sort([:_id, -1]).
            aggregate.
            should eq [
              {"_id" => true,  "paws" => 2},
              {"_id" => false, "paws" => 4}]
        end

        it 'allows you to take the last value for a group' do
          subject.
            sort(:name).
            group(:stray).
            last(:paws).
            sort([:_id, -1]).
            aggregate.
            should eq [
              {"_id" => true,  "paws" => 2},
              {"_id" => false, "paws" => 17}]
        end

        it 'allows you to take the max value for a group' do
          subject.
            sort(:name).
            group(:stray).
            max(:paws).
            sort([:_id, -1]).
            aggregate.
            should eq [
              {"_id" => true,  "paws" => 2},
              {"_id" => false, "paws" => 17}]
        end

        it 'allows you to take the min value for a group' do
          subject.
            sort(:name).
            group(:stray).
            min(:paws).
            sort([:_id, -1]).
            aggregate.
            should eq [
              {"_id" => true,  "paws" => 2},
              {"_id" => false, "paws" => 3}]
        end

        it 'allows you to take the average value for a group' do
          subject.
            sort(:name).
            group(:stray).
            average(:paws).
            sort([:_id, -1]).
            aggregate.
            should eq [
              {"_id" => true,  "paws" => 2},
              {"_id" => false, "paws" => 8}]
        end

        it 'allows you to build a set of values' do
          subject.
            group(:stray).
            push(:paws).
            sort([:_id, -1]).
            transform{|r| r.merge('paws' => r['paws'].sort) }.
            aggregate.
            should eq [
              {"_id" => true,  "paws" => [2]},
              {"_id" => false, "paws" => [3,4,17]}]
        end

      end
    end
  end
end
