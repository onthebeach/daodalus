require 'spec_helper'

module Daodalus
  module DSL
    describe Select do
      let (:dao) { stub }
      let (:select) { ->(*fields) { Select.new(dao, fields) }}

      it 'accepts multiple fields (_id is not included by default)' do
        select.(:cats, :dogs).select_clause.
          should eq ({'_id' => 0, 'cats' => 1, 'dogs' => 1})
      end

      it 'allows chaining using with' do
        select.(:cats).and(:dogs).select_clause.
          should eq ({'_id' => 0, 'cats' => 1, 'dogs' => 1})
      end

      describe "#slice" do
        it 'creates a slice clause' do
          select.(:cats).and(:dogs).slice(3).
            select_clause.
            should eq ({'_id' => 0, 'cats' => 1, 'dogs' => {'$slice' => 3}})
        end
      end

      describe "#elem_match" do
        it 'creates an elemMatch clause' do
          select.(:cats).elem_match(:paws, 3).
            select_clause.
            should eq ({'_id' => 0, 'cats' => {'$elemMatch' => {'paws' => 3}}})
        end
      end
    end
  end
end

