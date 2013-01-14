require 'spec_helper'

module Daodalus
  module DSL
    describe Pipe do

      let (:operator) { stub }
      let (:block) { ->(results){ results.min } }

      let (:pipe) { Pipe.new(operator, block, []) }

      it 'takes an operator and block' do
        pipe
      end

      describe "#pipe" do
        it 'allows the chaining of pipes' do
          operator.should_receive(:find).and_return([2,4])
          pipe.pipe(&:succ).find.should eq 3
        end
      end

      describe "#extract" do
        let (:block) { ->(r){ r } }
        it 'extracts a specific key from the result' do
          operator.should_receive(:find).and_return([{'a' => 1},{'a' => 2}])
          pipe.extract(:a).find.should eq [1,2]
        end
      end

      describe "#aggregate" do
        it 'applies the block to each result' do
          operator.should_receive(:aggregate).and_return([2,4])
          pipe.aggregate.should eq 2
        end
      end

      describe "#find" do
        it 'applies the block to each result' do
          operator.should_receive(:find).and_return([2,4])
          pipe.find.should eq 2
        end
      end

      describe "#find_one" do
        context "there is a result" do
          it 'applies the block to the result' do
            operator.should_receive(:find_one).and_return([7,5])
            pipe.find_one.should eq 5
          end
        end
        context "there is no result" do
          it 'returns nil' do
            operator.should_receive(:find_one).and_return(nil)
            pipe.find_one.should be_nil
          end
        end
      end

      describe "#find_and_modify" do
        context "there is a result" do
          it 'applies the block to the result' do
            operator.should_receive(:find_and_modify).and_return([99,5])
            pipe.find_and_modify.should eq 5
          end
        end
        context "there is no result" do
          it 'returns nil' do
            operator.should_receive(:find_and_modify).and_return(nil)
            pipe.find_and_modify.should be_nil
          end
        end
      end
    end
  end
end
