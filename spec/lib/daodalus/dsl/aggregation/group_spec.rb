require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Group do

        let (:dao) { DAO.new(:animalhouse, :cats) }

        before do
          dao.insert('name'  => 'Terry',
                     'paws'  => 3,
                     'likes' => ['tuna', 'catnip'],
                     'foods' => [{'type' => 'dry', 'name' => 'go cat'},
                                 {'type' => 'wet', 'name' => 'whiskas'}])

          dao.insert('name'  => 'Jemima',
                     'paws'  => 3,
                     'likes' => ['tuna', 'ginger beer'],
                     'foods' => [{'type' => 'cat', 'name' => 'go cat'},
                                 {'type' => 'dog', 'name' => 'whiskas'}])
        end

        it 'can group on a single field' do
          dao.group_by('$foods.type').aggregate.should eq [
            {"_id"=>["cat", "dog"]},
            {"_id"=>["dry", "wet"]}
          ]
        end

        it 'can group by a hash of fields' do
          dao.group_by(cat: '$name', brand: '$foods.name').aggregate.should eq [
            {"_id"=>{"cat"=>"Jemima", "brand"=>["go cat", "whiskas"]}},
            {"_id"=>{"cat"=>"Terry", "brand"=>["go cat", "whiskas"]}}
          ]
        end

        it 'can sum a set of fields' do
          dao.group_by(1).sum("$paws").as(:paws).aggregate.should eq [{"_id"=>1, "paws"=>6}]
        end

        it 'can build up a unique set of aggregate values' do
          dao.insert('name'  => 'Terry', 'paws' => 3)
          dao.group_by("$paws").distinct("$name").as(:cats).aggregate.should eq [
            {"_id"=>3, "cats"=>["Jemima", "Terry"]}
          ]
        end

        it 'can build up a non-unique set of aggregate values' do
          dao.insert('name'  => 'Terry', 'paws' => 3)
          dao.group_by(:"$paws").collect("$name").as(:cats).aggregate.should eq [
            {"_id"=>3, "cats"=>["Terry", "Jemima", "Terry"]}
          ]
        end

        it 'can get the first value for an aggregate field' do
          dao.group_by(1).first('$name').as(:name).aggregate.should eq [
            {"_id"=>1, "name"=>"Terry"}
          ]
        end

        it 'can get the last value for an aggregate field' do
          dao.group_by(1).last('$name').as(:name).aggregate.should eq [
            {"_id"=>1, "name"=>"Jemima"}
          ]
        end

        it 'can get the min value for an aggregate field' do
          dao.insert('name'  => 'Terry', 'paws' => 7)
          dao.group_by(1).min('$paws').as(:paws).aggregate.should eq [
            {"_id"=>1, "paws"=>3}
          ]
        end

        it 'can get the max value for an aggregate field' do
          dao.insert('name'  => 'Terry', 'paws' => 7)
          dao.group_by(1).max('$paws').as(:paws).aggregate.should eq [
            {"_id"=>1, "paws"=>7}
          ]
        end

        it 'can get the average value for an aggregate field' do
          dao.insert('name'  => 'Terry', 'paws' => 24)
          dao.group_by(1).average('$paws').as(:paws).aggregate.should eq [
            {"_id"=>1, "paws"=>10}
          ]
        end

      end
    end
  end
end
