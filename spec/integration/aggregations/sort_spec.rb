require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Sort do

        before :each do
          CatDAO.remove_all
          CatDAO.insert(name: 'Felix',   stray: false, paws: 4)
          CatDAO.insert(name: 'Jeffrey', stray: false, paws: 3)
          CatDAO.insert(name: 'Louise',  stray: false, paws: 3)
          CatDAO.insert(name: 'Cat',     stray: true,  paws: 3)
        end

        subject { CatDAO }

        it "allows you to sort" do
          subject.
            sort(:paws, [:name, :desc]).
            transform{|r| r.delete('_id'); r }.
            aggregate.should eq [
              {'name' => 'Louise', 'stray' => false, 'paws' => 3},
              {'name' => 'Jeffrey', 'stray' => false, 'paws' => 3},
              {'name' => 'Cat', 'stray' => true, 'paws' => 3},
              {'name' => 'Felix', 'stray' => false, 'paws' => 4}
          ]
        end
      end
    end
  end
end

