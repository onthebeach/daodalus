require 'spec_helper'


describe "#find" do

  before :each do
    CatDAO.remove_all
  end

  subject { CatDAO }

  it 'works when the last link in the chain is a where clause' do
    subject.insert(name: "Felix", paws: 4)

    subject.
      select(:paws).
      where(:name).eq('Felix').
      find.first.should eq ({"paws" => 4})
  end

  it 'works when the last link in the chain is a select clause' do
    subject.insert(name: "Ginger", paws: 3)

    subject.
      select(:paws).
      find.first.should eq ({"paws" => 3})
  end

end
