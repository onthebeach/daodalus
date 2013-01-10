require 'spec_helper'

module Daodalus
  module DSL
    describe Transform do
      let (:operator) { stub }
      let (:block) { ->(result){ result * 2 } }

      let (:transform) { Transform.new(operator, block, []) }

      it 'takes an operator and block' do
        transform
      end

      describe "#transform" do
        it 'allows the chaining of transforms' do
          operator.should_receive(:find).and_return([2,4])
          transform.transform(&:succ).find.should eq [5,9]
        end
      end

      describe "#extract" do
        let (:block) { ->(r){ r } }
        it 'extracts a specific key from the result' do
          operator.should_receive(:find).and_return([{'a' => 1},{'a' => 2}])
          transform.extract(:a).find.should eq [1,2]
        end
      end

      describe "#aggregate" do
        it 'applies the block to each result' do
          operator.should_receive(:aggregate).and_return([2,4])
          transform.aggregate.should eq [4,8]
        end
      end

      describe "#find" do
        it 'applies the block to each result' do
          operator.should_receive(:find).and_return([2,4])
          transform.find.should eq [4,8]
        end
      end

      describe "#find_one" do
        context "there is a result" do
          it 'applies the block to the result' do
            operator.should_receive(:find_one).and_return(5)
            transform.find_one.should eq 10
          end
        end
        context "there is no result" do
          it 'returns nil' do
            operator.should_receive(:find_one).and_return(nil)
            transform.find_one.should be_nil
          end
        end
      end

      describe "#find_and_modify" do
        context "there is a result" do
          it 'applies the block to the result' do
            operator.should_receive(:find_and_modify).and_return(5)
            transform.find_and_modify.should eq 10
          end
        end
        context "there is no result" do
          it 'returns nil' do
            operator.should_receive(:find_and_modify).and_return(nil)
            transform.find_and_modify.should be_nil
          end
        end
      end
    end
  end
end
