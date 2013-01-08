require 'spec_helper'

module Daodalus
  module DSL
    describe Transform do

      before :each do
        CatDAO.remove_all
      end

      subject { CatDAO }

      it 'works when doing a find with no parameters' do
        subject.insert(name: 'Felix', paws: 4)

        subject.
          transform{ |r| r.fetch('paws') }.
          find.
          should eq [4]
      end

      it 'works when doing a find with a where as the last element' do
        subject.insert(name: 'Felix', paws: 4)

        subject.
          where(:paws).eq(4).
          transform{ |r| r.fetch('paws') }.
          find.
          should eq [4]
      end

      it 'works when doing a find with a select as the last element' do
        subject.insert(name: 'Felix', paws: 4)

        subject.
          select(:paws).
          transform{ |r| r.fetch('paws') }.
          find.
          should eq [4]
      end

      it 'works when doing a find_and_modify with an update as the last element' do
        subject.insert(name: 'Felix', paws: 4)

        subject.
          set(:paws, 3).
          transform{ |r| r.fetch('paws') }.
          find_and_modify(new: true).
          should eq 3
      end
    end
  end
end
