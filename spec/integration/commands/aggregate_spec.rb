require 'spec_helper'

describe "#aggregate" do

  before :each do
    CatDAO.remove_all
  end

  subject { CatDAO }

  it 'makes an aggregation framework call' do
    subject.insert(name: "Felix", paws: 4)

    subject.
      match(:paws).gt(3).
      project(:name).
      aggregate.should eq [{'name' => 'Felix'}]
  end

end
