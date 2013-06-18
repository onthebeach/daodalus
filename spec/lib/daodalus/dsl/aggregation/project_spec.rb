require 'spec_helper'

module Daodalus
  module DSL
    module Aggregation
      describe Project do

        let (:dao) { DAO.new(:animalhouse, :cats) }

        before do
          dao.insert('name'  => 'Terry',
                     'nickname' => 'Terry',
                     'breed' => 'Tabby',
                     'paws'  => 3,
                     'likes' => ['tuna', 'catnip'],
                     'foods' => [{'type' => 'dry', 'name' => 'go cat'},
                                 {'type' => 'wet', 'name' => 'whiskas'}])

        end

        it 'can project a list of fields' do
          dao.project(:name, :paws, 'foods.name').aggregate.should eq [
            {'name' => 'Terry', 'paws' => 3, "foods"=>[{"name"=>"go cat"}, {"name"=>"whiskas"}] }
          ]
        end

        it 'can rename fields' do
          dao.project(feet: '$paws').aggregate.should eq ['feet' => 3]
        end

        it 'can be chained with other projects' do
          dao.project(:paws).and(cat: '$name').aggregate.should eq ['paws' => 3, 'cat' => 'Terry']
        end

        it 'can alias fields using "as"' do
          dao.project(:paws).and("$name").as(:cat).aggregate.should eq ['paws' => 3, 'cat' => 'Terry']
        end

        it 'implements the #eq function' do
          dao.project("$name").eq("$nickname").as(:thingy).aggregate.should eq [ 'thingy' => true ]
          dao.project("$name").eq("$breed").as(:thingy).aggregate.should eq [ 'thingy' => false ]
          dao.project("$name").eq('Terry').as(:thingy).aggregate.should eq [ 'thingy' => true ]
        end

        it 'implements the #plus function' do
          dao.project("$paws", 1).plus("$paws", 4).as(:thingy).aggregate.should eq [ 'thingy' => 11 ]
        end

        it 'implements the #divide function' do
          dao.project("$paws").divided_by("$paws").as(:thingy).aggregate.should eq [ 'thingy' => 1 ]
        end

        it 'implements the #multiply function' do
          dao.project("$paws").multiplied_by("$paws").as(:thingy).aggregate.should eq [ 'thingy' => 9 ]
        end

        it 'implements the #subtract function' do
          dao.project("$paws").minus("$paws").as(:thingy).aggregate.should eq [ 'thingy' => 0 ]
        end

        it 'implements the #mod function' do
          dao.project("$paws").mod(5).as(:thingy).aggregate.should eq [ 'thingy' => 3 ]
        end

        it 'can create nested documents' do
          dao.project(
            dao.project("$paws").as(:feet).and(name: "$name"),
          ).as(:cat).aggregate.should eq [{"cat"=>{"feet"=>3, "name"=>"Terry"}}]
        end

      end
    end
  end
end
