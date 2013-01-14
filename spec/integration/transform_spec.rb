require 'spec_helper'

module Daodalus
  module DSL

    describe Transform do

      CatDAO.instance_eval do
        def square(x)
          x * x
        end
        def double(x)
          x + x
        end
      end

      before :each do
        CatDAO.remove_all
        subject.insert(name: 'Felix', paws: 4)
      end

      subject { CatDAO }

      it 'can accept a symbol instead of a block' do
        subject.
          transform{ |r| r.fetch('paws') }.
          transform(:square).find.
          should eq [16]
      end

      it 'can be chained with pipe' do
        subject.
          extract(:paws).
          transform(:square).
          pipe(&:first).
          pipe(:double).
          find.should eq 32
      end

      it 'works when doing a find with no parameters' do
        subject.
          transform{ |r| r.fetch('paws') }.
          find.
          should eq [4]
      end

      it 'works when doing a find with a where as the last element' do
        subject.
          where(:paws).eq(4).
          transform{ |r| r.fetch('paws') }.
          find.
          should eq [4]
      end

      it 'works when doing a find with a select as the last element' do
        subject.
          select(:paws).
          transform{ |r| r.fetch('paws') }.
          find.
          should eq [4]
      end

      it 'works when doing a find_and_modify with an update as the last element' do
        subject.
          set(:paws, 3).
          transform{ |r| r.fetch('paws') }.
          find_and_modify(new: true).
          should eq 3
      end
    end
  end
end
