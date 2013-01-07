require 'spec_helper'

describe "#remove" do

  before :each do
    CatDAO.remove_all
  end

  subject { CatDAO }

  it 'works when the last link in the chain is a where clause' do
    subject.insert(name: "Felix", paws: 4)

    subject.
      where(:name).eq('Felix').
      remove

    subject.count.should eq 0
  end

end
