require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Unwind do

        before :each do
          CatDAO.remove_all
          CatDAO.insert(name: 'Felix',   favourite_foods: ['mice', 'fish'])
          CatDAO.insert(name: 'Jeffrey', favourite_foods: ['blue cheese', 'vomit'])
        end

        subject { CatDAO }

        it "allows you to unwind array elements" do
          subject.
            unwind(:favourite_foods).
            sort(:favourite_foods).
            project(:favourite_foods).as(:food).
            transform{ |r| r.fetch('food') }.
            aggregate.should eq ['blue cheese', 'fish', 'mice', 'vomit']
        end
      end
    end
  end
end


