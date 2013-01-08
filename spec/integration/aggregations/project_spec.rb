require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Project do

        before :each do
          CatDAO.remove_all
          CatDAO.insert(
            name: 'Felix',
            paws: 4,
            favourite_foods: {
            fish: 3,
            mice: 2
          })
        end

        subject { CatDAO }
        let (:project) { ->(*fields) {subject.project(*fields)} }

        it "allows selecting a field" do
          subject.
            project(:name).
            aggregate.
            should eq [{'name' => 'Felix'}]
        end

        it "allows selecting multiple fields" do
          subject.
            project(:name, :paws).
            aggregate.
            should eq [{'name' => 'Felix', 'paws' => 4}]
        end

        it "allows renaming fields" do
          subject.
            project(:name).
            and('favourite_foods.mice').as(:mouse_index).
            aggregate.
            should eq [{'name' => 'Felix', 'mouse_index' => 2}]
        end

        it "allows creation of nested documents" do
          subject.
            project(
              project.(:name).
              and(:paws).minus(1).as(:paws)
          ).as(:info).
            aggregate.
            should eq [{'info' => {'name' => 'Felix', 'paws' => 3}}]
        end

        it "allows fields to be added together" do
          subject.
            project('favourite_foods.mice').
            plus('favourite_foods.fish').
            as(:food_total).aggregate.
            should eq [{'food_total' => 5}]
        end

        it "allows fields to be subtracted from each other" do
          subject.
            project('favourite_foods.mice').
            minus('favourite_foods.fish').
            as(:food_total).aggregate.
            should eq [{'food_total' => -1}]
        end

        it "allows fields to be divided by each other" do
          subject.
            project(:paws).
            divided_by('favourite_foods.mice').
            as(:food_total).aggregate.
            should eq [{'food_total' => 2}]
        end

        it "allows the modulus of two fields divided by each other to be taken" do
          subject.
            project('favourite_foods.fish').
            mod('favourite_foods.mice').
            as(:food_total).aggregate.
            should eq [{'food_total' => 1}]
        end

        it "allows two fields to be multiplied" do
          subject.
            project('favourite_foods.fish').
            multiplied_by('favourite_foods.mice').
            as(:food_total).aggregate.
            should eq [{'food_total' => 6}]
        end

        it "allows fields to be added to a constant" do
          subject.
            project('favourite_foods.mice').
            plus(5).
            as(:food_total).aggregate.
            should eq [{'food_total' => 7}]
        end

        it "allows a constant to be subtracted" do
          subject.
            project('favourite_foods.mice').
            minus(6).
            as(:food_total).aggregate.
            should eq [{'food_total' => -4}]
        end

        it "allows fields to be divided by a constant" do
          subject.
            project(:paws).
            divided_by(8).
            as(:food_total).aggregate.
            should eq [{'food_total' => 0.5}]
        end

        it "allows the modulus of a fields divided by a constant to be taken" do
          subject.
            project('favourite_foods.fish').
            mod(2).
            as(:food_total).aggregate.
            should eq [{'food_total' => 1}]
        end

        it "allows fields to be multiplied by a constant" do
          subject.
            project('favourite_foods.fish').
            multiplied_by(7).
            as(:food_total).aggregate.
            should eq [{'food_total' => 21}]
        end
      end
    end
  end
end
