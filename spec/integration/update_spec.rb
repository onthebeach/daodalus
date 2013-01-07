require 'spec_helper'

describe "#update" do

  before :each do
    CatDAO.remove_all
  end

  subject { CatDAO }

  it 'works when the last link in the chain is a where clause' do
    subject.insert(name: "Felix", paws: 4)

    subject.
      inc(:paws).
      where(:name).eq('Felix').
      update

    subject.find_one.fetch('paws').should eq 5
  end

  it 'works when the last link in the chain is an update clause' do
    subject.insert(name: "Felix", paws: 4)

    subject.
      inc(:paws).
      update

    subject.find_one.fetch('paws').should eq 5
  end

end
