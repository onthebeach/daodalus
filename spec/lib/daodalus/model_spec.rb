require 'spec_helper'

class NestedTestModel
  include Daodalus::Model

  field :foo
  field :bar
end

class TestModel
  include Daodalus::Model

  field :x
  field :y, key: 'the_y_field'
  field :z, default: 5
  field :zz, default: lambda { 5 }
  has_one :single_nested, type: NestedTestModel
  has_many :multiple_nested, type: NestedTestModel
end

module Daodalus
  describe Model do
    let (:model) { TestModel.new('x' => 3,
                                 'the_y_field' => 4,
                                 'n' => '6',
                                 'f' => '4.7',
                                 's' => :oeu,
                                 'sym' => 'oeu',
                                 'date' => '20120405',
                                 'time' => '1123',
                                 'single_nested' => {
                                   'foo' => 1,
                                   'bar' => 2
                                 },
                                 'multiple_nested' => [
                                   {
                                     'foo' => 1,
                                     'bar' => 2
                                   },
                                   {
                                     'foo' => 3,
                                     'bar' => 4
                                   }
                                 ]) }

    it 'takes a result' do
      model
    end

    it 'defines fields with attr_readers' do
      model.x.should eq 3
    end

    it 'allows different names for keys' do
      model.y.should eq 4
    end

    it 'allows defaults' do
      model.z.should eq 5
    end

    it 'allows lambdas as defaults' do
      model.zz.should eq 5
    end

    it 'can have nested model fields' do
      model.single_nested.should be_a NestedTestModel
      model.single_nested.foo.should eq 1
      model.single_nested.bar.should eq 2
    end

    it 'can have has_many associations' do
      model.multiple_nested.should be_a Array
      model.multiple_nested.first.should be_a NestedTestModel
      model.multiple_nested.last.bar.should eq 4
    end

    it 'memoizes nested model fields' do
      NestedTestModel.should_receive(:new).with({"foo"=>1, "bar"=>2}).once.and_return(stub)
      model.single_nested
      model.single_nested
      model.single_nested
    end
  end
end
