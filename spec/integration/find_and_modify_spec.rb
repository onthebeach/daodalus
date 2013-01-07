require 'spec_helper'

describe "#find_and_modify" do

  before :each do
    CatDAO.remove_all
  end

  subject { CatDAO }

  it 'works when the last link in the chain is a where clause' do
    subject.insert(name: "Felix", paws: 4)

    subject.
      inc(:paws).
      where(:name).eq('Felix').
      find_and_modify(new: true).fetch("paws").should eq 5
  end

  it 'works when the last link in the chain is an update clause' do
    subject.insert(name: "Felix", paws: 4)

    subject.
      inc(:paws).
      find_and_modify(new: true).fetch("paws").should eq 5
  end

end
