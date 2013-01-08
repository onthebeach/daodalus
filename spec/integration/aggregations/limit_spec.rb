require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Limit do

        before :each do
          CatDAO.remove_all
          CatDAO.insert(name: 'Felix',   stray: false, paws: 4)
          CatDAO.insert(name: 'Jeffrey', stray: false, paws: 3)
          CatDAO.insert(name: 'Louise',  stray: false, paws: 17)
          CatDAO.insert(name: 'Cat',     stray: true,  paws: 2)
        end

        subject { CatDAO }

        it "allows you to limit the number of records returned" do
          subject.
            limit(2).
            aggregate.count.should eq 2
        end
      end
    end
  end
end
