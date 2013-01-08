require 'spec_helper'

describe "#projection" do

  before :each do
    CatDAO.remove_all
    CatDAO.insert(name: "Felix", paws: 4, numbers: [1,2,3,4,5])
  end

  subject { CatDAO }

  it 'allows taking a slice of an array' do

    subject.select(:paws).
      and(:numbers).slice(3).
      where(:name).eq('Felix').
      find_one.should eq ({"paws" => 4, "numbers" => [1,2,3]})
  end

end
