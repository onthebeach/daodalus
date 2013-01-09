require 'spec_helper'

describe "#projection" do

  before :each do
    CatDAO.remove_all
  end

  subject { CatDAO }

  it 'allows taking a slice of an array' do
    CatDAO.insert(name: "Felix", paws: 4, numbers: [1,2,3,4,5])
    subject.select(:paws).
      and(:numbers).slice(3).
      where(:name).eq('Felix').
      find_one.should eq ({"paws" => 4, "numbers" => [1,2,3]})
  end

  it 'can match an element of an array' do
    CatDAO.insert(
      name: "Felix",
      paws: 4,
      favourite_foods: [{name: 'fish', score: 3, name: 'vomit', score: 10}])

    subject.
      select(:favourite_foods).elem_match(:score, 10).
      find_one.should eq ({"favourite_foods" => [{"name"=>"vomit", "score"=>10}]})
  end
end
