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
  field :n, type: Integer
  field :f, type: Float
  field :s, type: String
  field :sym, type: Symbol
  field :date, type: Date
  field :time, type: Time
  field :nested, type: NestedTestModel
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
                                 'nested' => {
                                   'foo' => 1,
                                   'bar' => 2
                                 }) }

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

    it 'can convert fields to integers' do
      model.n.should be_a Integer
    end

    it 'can convert fields to float' do
      model.f.should be_a Float
    end

    it 'can convert fields to integers' do
      model.s.should be_a String
    end

    it 'can convert fields to integers' do
      model.sym.should be_a Symbol
    end

    it 'can convert fields to integers' do
      model.date.should be_a Date
    end

    it 'can convert fields to integers' do
      model.time.should be_a Time
    end

    it 'can have nested model fields' do
      model.nested.should be_a NestedTestModel
      model.nested.foo.should eq 1
      model.nested.bar.should eq 2
    end
  end
end
