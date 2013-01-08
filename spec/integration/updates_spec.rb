require 'spec_helper'

describe "update commands" do

  before :each do
    CatDAO.remove_all
    subject.insert(name: "Felix",
                   paws: 4,
                   favourite_foods: ['fish', 'mice'],
                   nicknames: ['Cat', 'Catty', 'Cato'])
  end

  subject { CatDAO }

  describe "#set" do
    it 'sets a value' do
      subject.
        set(:paws, 17).
        set(:tail, 'bushy').
        where(:name).eq('Felix').update

      subject.
        select(:tail, :paws).
        find_one.should eq ({'paws' => 17, 'tail' => 'bushy'})
    end
  end

  describe "#unset" do
    it 'unsets a value' do
      subject.
        unset(:paws).
        unset(:favourite_foods).
        where(:name).eq('Felix').update
      subject.find_one.fetch('paws', nil).should be_nil
      subject.find_one.fetch('favourite_foods', nil).should be_nil
    end
  end

  describe "#rename" do
    it 'renames the given key' do
      subject.
        rename(:paws, :feet).
        rename(:favourite_foods, :foods).
        where(:name).eq('Felix').update
      subject.find_one.fetch('paws', nil).should be_nil
      subject.find_one.fetch('feet').should eq 4
      subject.find_one.fetch('favourite_foods', nil).should be_nil
      subject.find_one.fetch('foods').should eq ['fish', 'mice']
    end
  end

  describe "#push" do
    context "given a single element" do
      it 'pushes element(s) onto an array' do
        subject.
          push(:favourite_foods, 'vomit').
          push(:favourite_drinks, 'milk').
          where(:name).eq('Felix').update
        subject.find_one.fetch('favourite_foods').should eq [
          'fish', 'mice', 'vomit'
        ]
        subject.find_one.fetch('favourite_drinks').should eq ['milk']
      end
    end
    context "given multiple elements" do
      it 'pushes element(s) onto an array' do
        subject.
          push(:favourite_foods, 'vomit', 'dead things').
          push(:favourite_drinks, 'milk', 'toilet water').
          where(:name).eq('Felix').update
        subject.find_one.fetch('favourite_foods').should eq [
          'fish', 'mice', 'vomit', 'dead things'
        ]
        subject.find_one.fetch('favourite_drinks').should eq ['milk', 'toilet water']
      end
    end
  end

  describe "#push_all" do
    it 'pushes element(s) onto an array' do

      subject.
        push_all(:favourite_foods, ['vomit', 'dead things']).
        push_all(:favourite_drinks, ['milk', 'toilet water']).
        where(:name).eq('Felix').update

      subject.find_one.fetch('favourite_foods').should eq [
        'fish', 'mice', 'vomit', 'dead things'
      ]
      subject.find_one.fetch('favourite_drinks').should eq ['milk', 'toilet water']
    end
  end

  describe "#add_to_set" do
    context "given a single element" do
      it 'add unique element(s) onto an array' do
        subject.
          add_to_set(:favourite_foods, 'fish').
          add_to_set(:favourite_drinks, 'milk').
          where(:name).eq('Felix').update

        subject.find_one.fetch('favourite_foods').should eq [
          'fish', 'mice'
        ]
        subject.find_one.fetch('favourite_drinks').should eq ['milk']
      end
    end
    context "given multiple elements" do
      it 'adds unique element(s) onto an array' do

        subject.
          add_to_set(:favourite_foods, 'vomit', 'mice', 'dead things').
          add_to_set(:favourite_drinks, 'milk', 'toilet water').
          where(:name).eq('Felix').update

        subject.find_one.fetch('favourite_foods').should eq [
          'fish', 'mice', 'vomit', 'dead things'
        ]
        subject.find_one.fetch('favourite_drinks').should eq ['milk', 'toilet water']
      end
    end
  end

  describe "#add_each_to_set" do
    it 'adds unique element(s) onto an array' do

      subject.
        add_each_to_set(:favourite_foods, ['vomit', 'mice', 'dead things']).
        add_each_to_set(:favourite_drinks, ['vomit', 'mice', 'dead things']).
        where(:name).eq('Felix').update

      subject.find_one.fetch('favourite_foods').should eq [
        'fish', 'mice', 'vomit', 'dead things'
      ]
    end
  end

  describe "#pop_first" do
    it 'pops the first value' do
      subject.
        pop_first(:favourite_foods).
        where(:name).eq('Felix').update

      subject.find_one.fetch('favourite_foods').should eq ['mice']
    end
    it 'stil works when it is not the first update command' do
      subject.set(:name, "Cat").
        pop_first(:favourite_foods).
        where(:name).eq('Felix').update
      subject.find_one.fetch('favourite_foods').should eq ['mice']
    end
  end

  describe "#pop_last" do
    it 'pops the last value' do
      subject.
        pop_last(:favourite_foods).
        where(:name).eq('Felix').update

      subject.find_one.fetch('favourite_foods').should eq ['fish']
    end
    it 'stil works when it is not the first update command' do
      subject.set(:name, "Cat").
        pop_last(:favourite_foods).
        where(:name).eq('Felix').update
      subject.find_one.fetch('favourite_foods').should eq ['fish']
    end
  end

  describe "#pull" do
    context "given a single element" do
      it 'removes that element from the array' do
        subject.
          pull(:favourite_foods, 'fish').
          pull(:nicknames, 'Cato').
          where(:name).eq('Felix').update

        subject.find_one.fetch('favourite_foods').should eq ['mice']
        subject.find_one.fetch('nicknames').should eq ['Cat', 'Catty']
      end
    end
    context "given multiple elements" do
      it 'removes those elements from the array' do

        subject.
          pull(:favourite_foods, 'vomit', 'mice', 'fish').
          pull(:nicknames, 'Catty', 'Cato').
          where(:name).eq('Felix').update

        subject.find_one.fetch('favourite_foods').should eq []
        subject.find_one.fetch('nicknames').should eq ['Cat']
      end
    end
  end

  describe "#pull_all" do
    it 'removes those elements from the array' do

      subject.
        pull_all(:favourite_foods, ['vomit', 'mice', 'fish']).
        pull_all(:nicknames, ['Cat', 'Cato']).
        where(:name).eq('Felix').update

      subject.find_one.fetch('favourite_foods').should eq []
      subject.find_one.fetch('nicknames').should eq ['Catty']
    end
  end

end

